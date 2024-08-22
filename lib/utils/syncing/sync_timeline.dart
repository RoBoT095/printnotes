import 'package:shared_preferences/shared_preferences.dart';

class LastSyncTime {
  static const String lastSyncKey = 'lastSyncTime';

  static Future<String> getLastSyncTimeString() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getInt(lastSyncKey);

    if (lastSync == null) {
      return 'Never';
    }

    final now = DateTime.now();
    final difference =
        now.difference(DateTime.fromMillisecondsSinceEpoch(lastSync));

    if (difference.inMinutes < 1) {
      return 'A moment ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 14) {
      return '${difference.inDays} days ago';
    } else {
      return 'A long time ago';
    }
  }

  static Future<void> setLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }
}
