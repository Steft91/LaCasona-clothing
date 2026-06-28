import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _localAuth = localAuth ?? LocalAuthentication(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  static const _biometricEnabledKey = 'biometric_enabled';
  static const _biometricEmailKey = 'biometric_email';
  static const _biometricPasswordKey = 'biometric_password';
  static const _biometricMethodsKey = 'biometric_methods';

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(AppConstants.usersCollection);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;
      return await _getUserDocument(uid, credential.user!.email ?? email);
    } on FirebaseAuthException catch (exception) {
      throw Exception(_friendlyAuthError(exception));
    }
  }

  @override
  Future<UserEntity> register(
    String nombre,
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;
      final user = UserModel(
        id: uid,
        nombre: nombre.trim(),
        email: email.trim(),
        fechaRegistro: DateTime.now(),
      );
      await _users.doc(uid).set(user.toFirestore());
      await credential.user!.updateDisplayName(nombre.trim());
      return user;
    } on FirebaseAuthException catch (exception) {
      throw Exception(_friendlyAuthError(exception));
    }
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _getUserDocument(firebaseUser.uid, firebaseUser.email ?? '');
  }

  @override
  Future<UserEntity> biometricLogin() async {
    final enabled = await isBiometricLoginEnabled();
    if (!enabled) {
      throw Exception('Activa el acceso biométrico desde tu perfil primero.');
    }

    final authenticated = await _authenticateWithBiometrics(
      'Confirma tu identidad para entrar a La Casona',
    );
    if (!authenticated) {
      throw Exception('No se pudo confirmar tu identidad.');
    }

    final email = await _secureStorage.read(key: _biometricEmailKey);
    final password = await _secureStorage.read(key: _biometricPasswordKey);
    if (email == null || password == null) {
      await disableBiometricLogin();
      throw Exception('Vuelve a iniciar sesión para configurar biometría.');
    }

    return login(email, password);
  }

  @override
  Future<bool> isBiometricLoginEnabled() async {
    final enabled = await _secureStorage.read(key: _biometricEnabledKey);
    final email = await _secureStorage.read(key: _biometricEmailKey);
    final password = await _secureStorage.read(key: _biometricPasswordKey);
    return enabled == 'true' && email != null && password != null;
  }

  @override
  Future<List<String>> getAvailableBiometricMethods() async {
    try {
      final canAuthenticate =
          await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (!canAuthenticate) return [];

      final biometrics = await _localAuth.getAvailableBiometrics();
      final methods = <String>{};

      if (biometrics.contains(BiometricType.face)) {
        methods.add('face');
      }
      if (biometrics.contains(BiometricType.fingerprint) ||
          biometrics.contains(BiometricType.strong) ||
          biometrics.contains(BiometricType.weak)) {
        methods.add('fingerprint');
      }

      return methods.toList();
    } on PlatformException {
      return [];
    }
  }

  @override
  Future<List<String>> getEnabledBiometricMethods() async {
    final stored = await _secureStorage.read(key: _biometricMethodsKey);
    if (stored == null || stored.trim().isEmpty) return [];
    return stored
        .split(',')
        .map((method) => method.trim())
        .where((method) => method.isNotEmpty)
        .toList();
  }

  @override
  Future<void> enableBiometricLogin(
    String password,
    List<String> methods,
  ) async {
    final currentUser = _auth.currentUser;
    final email = currentUser?.email;
    if (email == null) {
      throw Exception('Inicia sesión antes de activar biometría.');
    }
    if (methods.isEmpty) {
      throw Exception('Elige al menos una opción biométrica.');
    }

    final availableMethods = await getAvailableBiometricMethods();
    final invalidMethods = methods.where(
      (method) => !availableMethods.contains(method),
    );
    if (invalidMethods.isNotEmpty) {
      throw Exception(
        'Esa opción biométrica no está disponible en tu teléfono.',
      );
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (exception) {
      throw Exception(_friendlyAuthError(exception));
    }

    final authenticated = await _authenticateWithBiometrics(
      'Confirma tu identidad para activar el acceso biométrico',
    );
    if (!authenticated) {
      throw Exception('No se pudo confirmar tu identidad.');
    }

    await _secureStorage.write(key: _biometricEnabledKey, value: 'true');
    await _secureStorage.write(key: _biometricEmailKey, value: email);
    await _secureStorage.write(key: _biometricPasswordKey, value: password);
    await _secureStorage.write(
      key: _biometricMethodsKey,
      value: methods.join(','),
    );
  }

  @override
  Future<void> disableBiometricLogin() async {
    await _secureStorage.delete(key: _biometricEnabledKey);
    await _secureStorage.delete(key: _biometricEmailKey);
    await _secureStorage.delete(key: _biometricPasswordKey);
    await _secureStorage.delete(key: _biometricMethodsKey);
  }

  Future<UserEntity> _getUserDocument(String uid, String fallbackEmail) async {
    final doc = await _users.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromFirestore(doc);
    }

    final user = UserModel(
      id: uid,
      nombre: _auth.currentUser?.displayName ?? 'Cliente',
      email: fallbackEmail,
      fechaRegistro: DateTime.now(),
    );
    await _users.doc(uid).set(user.toFirestore());
    return user;
  }

  Future<bool> _authenticateWithBiometrics(String reason) async {
    try {
      final canAuthenticate =
          await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (!canAuthenticate) {
        throw Exception('Tu dispositivo no tiene biometría disponible.');
      }

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (exception) {
      if (exception.code == 'no_fragment_activity') {
        throw Exception(
          'La biometría necesita reiniciar la app después de esta actualización.',
        );
      }
      throw Exception('No se pudo abrir la verificación biométrica.');
    }
  }

  String _friendlyAuthError(FirebaseAuthException exception) {
    return switch (exception.code) {
      'invalid-email' => 'El correo no tiene un formato válido.',
      'user-not-found' => 'No existe una cuenta con ese correo.',
      'wrong-password' => 'La contraseña no es correcta.',
      'invalid-credential' =>
        'Correo o contraseña incorrectos. Revisa los datos e intenta de nuevo.',
      'email-already-in-use' => 'Ese correo ya tiene una cuenta registrada.',
      'weak-password' => 'La contraseña debe tener al menos 6 caracteres.',
      'network-request-failed' =>
        'No hay conexión. Revisa tu internet e intenta otra vez.',
      'too-many-requests' =>
        'Demasiados intentos. Espera un momento antes de volver a probar.',
      _ => 'No se pudo completar la autenticación. Intenta de nuevo.',
    };
  }
}
