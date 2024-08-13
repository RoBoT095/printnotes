import 'package:shared_preferences/shared_preferences.dart';

class UserLayoutPref {
  static Future<void> setLayoutView(String layoutView) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('layoutView', layoutView);
  }

  static Future<String> getLayoutView() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('layoutView') ?? 'grid';
  }
}
