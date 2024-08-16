import 'package:shared_preferences/shared_preferences.dart';

// Left it as a string in case I want to add more layouts
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
