import 'package:shared_preferences/shared_preferences.dart';

class UserFirstTime {
  static Future<void> setShowIntro(bool showIntro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstTimeUser', showIntro);
  }

  static Future<bool> get getShowIntro async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstTimeUser') ?? true;
  }
}
