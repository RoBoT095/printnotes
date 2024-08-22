import 'package:shared_preferences/shared_preferences.dart';

class UserSyncPref {
  static Future<void> setSyncService(String service) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sync_service', service);
  }

  static Future<String> getSyncService() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sync_service') ?? 'Disabled';
  }

  static Future<void> setConnectionType(String internet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('connection_type', internet);
  }

  static Future<String> getConnectionType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('connection_type') ?? 'WiFi';
  }
}
