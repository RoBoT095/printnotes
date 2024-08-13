import 'package:shared_preferences/shared_preferences.dart';

class UserThemingPref {
  static Future<void> setThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'system';
  }

  static Future<void> setColorScheme(String colorScheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('colorScheme', colorScheme);
  }

  static Future<String> getColorScheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('colorScheme') ?? 'default';
  }
}
