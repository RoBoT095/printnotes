import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:printnotes/utils/handlers/item_navigation.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_sort.dart';
import 'package:printnotes/utils/configs/user_intro.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class SettingsLoader {
  static Future<bool> getShowIntro() async {
    final showIntro = await UserFirstTime.getShowIntro;
    return showIntro;
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    final directory = await DataPath.selectedDirectory;
    final layout = await UserLayoutPref.getLayoutView();
    final previewLength = await UserLayoutPref.getNotePreviewLength();
    final theme = await UserThemingPref.getThemeMode();
    final colorScheme = await UserThemingPref.getColorScheme();
    final sortOrder = await UserSortPref.getSortOrder();
    final useLatex = await UserLatexPref.getLatexSupport();

    return {
      'directory': directory,
      'layout': layout,
      'previewLength': previewLength,
      'theme': theme,
      'colorScheme': colorScheme,
      'sortOrder': sortOrder,
      'useLatex': useLatex,
    };
  }

  static Future<String?> pickDirectory() async {
    final pickedDirectory = await DataPath.pickDirectory();
    if (pickedDirectory != null) {
      await DataPath.setSelectedDirectory(pickedDirectory);
    }
    return pickedDirectory;
  }

  static Future<Map<String, dynamic>> loadItems({
    String? folderPath,
    bool doReload = false,
  }) async {
    final mainPath = await DataPath.selectedDirectory;
    final directory = folderPath ?? mainPath;
    String sortOrder = await UserSortPref.getSortOrder();
    String currentFolderName;

    if (directory != null) {
      final items = StorageSystem.listFolderContents(directory);
      final sortedItems = ItemSortHandler.sortItems(items, sortOrder);

      if (directory != mainPath) {
        currentFolderName = path.basename(directory);
      } else {
        currentFolderName = 'All Notes';
      }

      if (doReload) {
        folderPath = mainPath;
        ItemNavHandler.folderHistory.clear();
      }

      return {
        'items': sortedItems,
        'currentPath': directory,
        'currentFolderName': currentFolderName,
      };
    }

    return {
      'items': <FileSystemEntity>[],
      'currentPath': null,
      'currentFolderName': 'All Notes',
    };
  }
}
