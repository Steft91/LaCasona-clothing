import 'package:flutter/foundation.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository);

  final AuthRepository _authRepository;

  UserEntity? user;
  bool isLoading = false;
  bool isBiometricEnabled = false;
  List<String> availableBiometricMethods = [];
  List<String> enabledBiometricMethods = [];
  String? error;

  bool get isAuthenticated => user != null;

  Future<void> loadCurrentUser() async {
    await _guard(() async {
      user = await _authRepository.getCurrentUser();
      isBiometricEnabled = await _authRepository.isBiometricLoginEnabled();
      availableBiometricMethods = await _authRepository
          .getAvailableBiometricMethods();
      enabledBiometricMethods = await _authRepository
          .getEnabledBiometricMethods();
    });
  }

  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      error = 'Ingresa email y contraseña';
      notifyListeners();
      return false;
    }

    var success = false;
    await _guard(() async {
      user = await _authRepository.login(email, password);
      isBiometricEnabled = await _authRepository.isBiometricLoginEnabled();
      availableBiometricMethods = await _authRepository
          .getAvailableBiometricMethods();
      enabledBiometricMethods = await _authRepository
          .getEnabledBiometricMethods();
      success = true;
    });
    return success;
  }

  Future<bool> register({
    required String nombre,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if ([
      nombre.trim(),
      email.trim(),
      password,
      confirmPassword,
    ].any((value) => value.isEmpty)) {
      error = 'Completa todos los campos';
      notifyListeners();
      return false;
    }
    if (password != confirmPassword) {
      error = 'Las contraseñas no coinciden';
      notifyListeners();
      return false;
    }

    var success = false;
    await _guard(() async {
      user = await _authRepository.register(nombre, email, password);
      isBiometricEnabled = await _authRepository.isBiometricLoginEnabled();
      availableBiometricMethods = await _authRepository
          .getAvailableBiometricMethods();
      enabledBiometricMethods = await _authRepository
          .getEnabledBiometricMethods();
      success = true;
    });
    return success;
  }

  Future<bool> biometricLogin() async {
    var success = false;
    await _guard(() async {
      user = await _authRepository.biometricLogin();
      isBiometricEnabled = true;
      enabledBiometricMethods = await _authRepository
          .getEnabledBiometricMethods();
      success = true;
    });
    return success;
  }

  Future<bool> enableBiometricLogin(
    String password,
    List<String> methods,
  ) async {
    if (password.isEmpty) {
      error = 'Ingresa tu contraseña para activar biometría';
      notifyListeners();
      return false;
    }
    if (methods.isEmpty) {
      error = 'Elige huella, rostro o ambas opciones';
      notifyListeners();
      return false;
    }

    var success = false;
    await _guard(() async {
      await _authRepository.enableBiometricLogin(password, methods);
      isBiometricEnabled = true;
      enabledBiometricMethods = await _authRepository
          .getEnabledBiometricMethods();
      success = true;
    });
    return success;
  }

  Future<void> disableBiometricLogin() async {
    await _guard(() async {
      await _authRepository.disableBiometricLogin();
      isBiometricEnabled = false;
      enabledBiometricMethods = [];
    });
  }

  Future<void> logout() async {
    await _guard(() async {
      await _authRepository.logout();
      user = null;
      isBiometricEnabled = await _authRepository.isBiometricLoginEnabled();
      enabledBiometricMethods = await _authRepository
          .getEnabledBiometricMethods();
    });
  }

  String get biometricSummary {
    if (!isBiometricEnabled || enabledBiometricMethods.isEmpty) {
      return 'Configúralo antes de cerrar sesión.';
    }
    return 'Activo: ${enabledBiometricMethods.map(methodLabel).join(' y ')}.';
  }

  String methodLabel(String method) {
    return switch (method) {
      'face' => 'rostro',
      'fingerprint' => 'huella',
      _ => method,
    };
  }

  Future<void> _guard(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (exception) {
      error = exception.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
