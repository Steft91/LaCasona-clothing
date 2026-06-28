import '../entities/user_entity.dart';

/// Contract for authentication operations.
abstract class AuthRepository {
  /// Sign in with email and password. Returns the authenticated user.
  Future<UserEntity> login(String email, String password);

  /// Create a new account and persist user data in Firestore.
  Future<UserEntity> register(String nombre, String email, String password);

  /// Sign out the current user.
  Future<void> logout();

  /// Get the currently authenticated user, or `null` if none.
  Future<UserEntity?> getCurrentUser();

  /// Authenticate using device biometrics (Face ID / fingerprint).
  /// Returns the signed-in user if biometric authentication succeeded.
  Future<UserEntity> biometricLogin();

  /// Returns whether the user configured biometric login in this device.
  Future<bool> isBiometricLoginEnabled();

  /// Returns biometric methods available on this device.
  Future<List<String>> getAvailableBiometricMethods();

  /// Returns biometric methods enabled for La Casona on this device.
  Future<List<String>> getEnabledBiometricMethods();

  /// Enables biometric login for the current user on this device.
  Future<void> enableBiometricLogin(String password, List<String> methods);

  /// Removes biometric login from this device.
  Future<void> disableBiometricLogin();
}
