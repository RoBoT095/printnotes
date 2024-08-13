import 'package:shared_preferences/shared_preferences.dart';

class UserSortPref {
  static Future<void> setSortOrder(String sortOrder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortOrder', sortOrder);
  }

  static Future<String> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sortOrder') ?? 'default';
  }
}
// TODO: Link sort order to main.dart
