import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServerCredentials {
  static const _storage = FlutterSecureStorage();
  static const _keyServerUrl = 'nextcloud_server_url';
  static const _keyUsername = 'nextcloud_username';
  static const _keyPassword = 'nextcloud_password';

  static Future<void> saveCredentials({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    await _storage.write(key: _keyServerUrl, value: serverUrl);
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
  }

  static Future<Map<String, String?>> getCredentials() async {
    return {
      'serverUrl': await _storage.read(key: _keyServerUrl),
      'username': await _storage.read(key: _keyUsername),
      'password': await _storage.read(key: _keyPassword),
    };
  }

  static Future<void> deleteCredentials() async {
    await _storage.delete(key: _keyServerUrl);
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
  }
}
