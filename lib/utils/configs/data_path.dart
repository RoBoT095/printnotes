import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPath {
  static String? _selectedDirectory;
  static const String _prefKey = 'selected_directory';

  static Future<String?> pickDirectory() async {
    if (Platform.isIOS) {
      final appDir = await getApplicationDocumentsDirectory();
      return appDir.path;
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        throw "Please allow storage permission to access files";
      }
    }
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

  // Hidden app config file called .main_config.json

  // Create and load contents of config file
  static Map<String, dynamic> loadJsonConfigFile() {
    final configFile = File(
        '$_selectedDirectory${Platform.pathSeparator}.printnotes${Platform.pathSeparator}main_config.json');
    if (!configFile.existsSync()) configFile.createSync(recursive: true);
    if (configFile.readAsStringSync().isEmpty) {
      configFile.writeAsStringSync('{}');
    }

    final configJsonString = configFile.readAsStringSync();
    return jsonDecode(configJsonString);
  }

  // Write to config file
  static void saveJsonConfigFile(Map<String, dynamic> configData) async {
    final configFile = File(
        '$_selectedDirectory${Platform.pathSeparator}.printnotes${Platform.pathSeparator}main_config.json');

    final configJsonString =
        const JsonEncoder.withIndent('  ').convert(configData);
    configFile.writeAsStringSync(configJsonString);
  }
}
