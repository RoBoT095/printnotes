import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_sort.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_preference.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';

class SettingsLoader {
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
