import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/item_sort.dart';
import 'package:printnotes/utils/configs/user_intro.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_layout.dart';
import 'package:printnotes/utils/configs/user_theming.dart';
import 'package:printnotes/utils/configs/user_sort.dart';

class SettingsLoader {
  static Future<bool> getShowIntro() async {
    final showIntro = await UserFirstTime.getShowIntro;
    return showIntro;
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    final directory = await DataPath.selectedDirectory;
    final layout = await UserLayoutPref.getLayoutView();
    final theme = await UserThemingPref.getThemeMode();
    final colorScheme = await UserThemingPref.getColorScheme();
    final deletedDuration = await StorageSystem.getDeletionDuration();
    final sortOrder = await UserSortPref.getSortOrder();

    return {
      'directory': directory,
      'layout': layout,
      'theme': theme,
      'colorScheme': colorScheme,
      'deletedDuration': deletedDuration,
      'sortOrder': sortOrder,
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
    String sortOrder = 'default',
    required List<String> folderHistory,
    bool doReload = false,
  }) async {
    final mainPath = await DataPath.selectedDirectory;
    final directory = folderPath ?? mainPath;

    if (directory != null) {
      final items = await StorageSystem.listFolderContents(directory);
      final sortedItems = ItemSortHandler.sortItems(items, sortOrder);

      final mainPathBasename =
          mainPath != null ? path.basename(mainPath) : null;
      final currentFolderName = path.basename(directory);

      if (doReload) {
        folderPath = mainPath;
        folderHistory.clear();
      }
      ItemNavHandler.updateFolderHistory(directory, folderHistory);

      return {
        'items': sortedItems,
        'currentPath': directory,
        'currentFolderName': currentFolderName,
        'mainPath': mainPathBasename,
        'folderHistory': folderHistory,
      };
    }

    return {
      'items': <FileSystemEntity>[],
      'currentPath': null,
      'currentFolderName': 'All Notes',
      'mainPath': null,
      'folderHistory': folderHistory,
    };
  }
}
