import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPath {
  static String? _selectedDirectory;
  static const String _prefKey = 'selected_directory';

  static Future<String?> pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      await setSelectedDirectory(selectedDirectory);
    }
    return selectedDirectory;
  }

  static Future<void> setSelectedDirectory(String dirPath) async {
    _selectedDirectory = dirPath;
    final dir = Directory(_selectedDirectory!);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, dirPath);
  }

  static Future<String?> get selectedDirectory async {
    if (_selectedDirectory == null) {
      final prefs = await SharedPreferences.getInstance();
      _selectedDirectory = prefs.getString(_prefKey);
      if (_selectedDirectory == null) {
        final appDir = await getApplicationDocumentsDirectory();
        return _selectedDirectory = appDir.path;
      }
      final dir = Directory(_selectedDirectory!);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }
    return _selectedDirectory;
  }
}
