import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/components/dialogs/select_location.dart';

class ItemMoveHandler {
  static Future<void> showMoveDialog(
    BuildContext context,
    List<FileSystemEntity> items,
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
            items: items,
          );
        },
      );

      if (newLocation != null) {
        if (items.length == 1) {
          await StorageSystem.moveItem(items.first, newLocation);
        } else {
          await StorageSystem.moveManyItems(items, newLocation);
        }
        loadItems();
      }
    }
  }
}
