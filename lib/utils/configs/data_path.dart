import 'dart:io';
import 'dart:convert';

import 'package:printnotes/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/utils/storage_system.dart';

class DataPath {
  static String? _selectedDirectory;
  static const String _prefKey = 'selected_directory';
  static String get hiddenFolderPath =>
      path.join(_selectedDirectory!, '.printnotes');

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

    App.localStorage.setString(_prefKey, dirPath);
  }

  static Future<String?> get selectedDirectory async {
    if (_selectedDirectory == null) {
      _selectedDirectory = App.localStorage.getString(_prefKey);
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

  static void addRecentFile(String path) {
    final recentList = App.localStorage.getStringList('recentFilesList') ?? [];

    final list = recentList.map((e) => jsonDecode(e)).toList();

    // Remove old entry with same path
    list.removeWhere((e) => e['path'] == path);

    // Add entry to the top of the list
    list.insert(
        0, {'path': path, 'openedAt': DateTime.now().millisecondsSinceEpoch});

    App.localStorage
        .setStringList('recentFilesList', list.map(jsonEncode).toList());
  }

  static List<String> loadRecentFiles(Duration within) {
    final recentList = App.localStorage.getStringList('recentFilesList') ?? [];
    final now = DateTime.now().millisecondsSinceEpoch;

    final items = recentList
        .map((e) => jsonDecode(e))
        .where((entry) {
          final openedAt = entry['openedAt'] as int;
          return (now - openedAt) <= within.inMilliseconds;
        })
        .map((e) => e['path'] as String)
        .toList();

    return items;
  }

  // Hidden app config file called .main_config.json

  static File get mainConfigFile =>
      File(path.join(hiddenFolderPath, 'main_config.json'));

  static File get toolbarConfigFile =>
      File(path.join(hiddenFolderPath, 'toolbar_config.json'));

  // Create and load contents of a config file
  static Map<String, dynamic> loadJsonConfigFile(File file) {
    if (!file.existsSync()) file.createSync(recursive: true);
    if (file.readAsStringSync().isEmpty) {
      file.writeAsStringSync('{}');
    }

    final fileString = file.readAsStringSync();
    return jsonDecode(fileString);
  }

  // Write to config file
  static void saveJsonConfigFile(
      File file, Map<String, dynamic> configData) async {
    final fileString = const JsonEncoder.withIndent('  ').convert(configData);
    file.writeAsStringSync(fileString);
  }

  // Deletes and regenerates json file
  static void deleteJsonConfigFile(File file) async {
    file.delete().then((_) => loadJsonConfigFile(file));
  }

  // Create a folder to store all the users upload images to use as a background

  // Path to folder with all the images
  static String get bgImagesFolderPath =>
      path.join(hiddenFolderPath, 'background_images');

  static Future<String?> uploadBgImage() async {
    if (!await Directory(bgImagesFolderPath).exists()) {
      await Directory(bgImagesFolderPath).create(recursive: true);
    }

    final pickedImage = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false, withData: true);
    if (pickedImage != null) {
      final data = pickedImage.files.single.bytes!;
      final file = await File(
              path.join(bgImagesFolderPath, pickedImage.files.single.name))
          .writeAsBytes(
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      return file.path;
    }
    return null;
  }

  static Future<List<String>> getBgImages() async {
    List<String> imgList = [];
    if (!await Directory(bgImagesFolderPath).exists()) {
      await Directory(bgImagesFolderPath).create(recursive: true);
    }
    final imagesDir =
        await StorageSystem.listFolderContents(Uri.parse(bgImagesFolderPath));
    for (FileSystemEntity item in imagesDir) {
      if (allowedImageExtensions.any((ext) => item.path.endsWith(ext))) {
        imgList.add(item.path);
      }
    }
    return imgList;
  }

  static Future<void> deleteBgImage(String path) async {
    await File(path).delete();
  }
}
