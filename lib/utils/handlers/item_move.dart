import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/view/components/select_location.dart';

class ItemMoveHandler {
  static Future<void> showMoveDialog(
    BuildContext context,
    FileSystemEntity item,
    Function loadItems,
  ) async {
    final String? baseDir = await DataPath.selectedDirectory;
    if (baseDir == null) return;

    if (context.mounted) {
      final String? newLocation = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SelectLocationDialog(
            baseDir: baseDir,
            currentItem: item,
          );
        },
      );

      if (newLocation != null) {
        await StorageSystem.moveItem(item, newLocation);
        loadItems();
      }
    }
  }
}
