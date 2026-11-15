import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Key used to persist the session token in secure storage.
const _kTokenKey = 'session_token';

/// Abstract interface for securely storing and retrieving the session token.
///
/// Implementations must provide secure, platform-appropriate persistence.
/// Used by [AuthLocalDataSource] and [AuthInterceptor] throughout the app.
abstract class SecureTokenStore {
  /// Persists [token] to secure storage, replacing any previously stored value.
  Future<void> saveToken(String token);

  /// Returns the currently stored token, or `null` if none is present.
  Future<String?> readToken();

  /// Removes the stored token from secure storage.
  Future<void> deleteToken();
}

/// Concrete implementation backed by [FlutterSecureStorage].
///
/// On Android, values are encrypted using the Android Keystore system.
/// On iOS, values are stored in the Keychain.
class SecureTokenStoreImpl implements SecureTokenStore {
  SecureTokenStoreImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _kTokenKey, value: token);
  }

  @override
  Future<String?> readToken() async {
    return _storage.read(key: _kTokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _kTokenKey);
  }
}
