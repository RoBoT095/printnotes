import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/components/dialogs/select_location.dart';

class ItemMoveHandler {
  static Future<void> showMoveDialog(
    BuildContext context,
    List<Uri> itemUris,
    Function loadItems,
  ) async {
    final String? baseDir = await DataPath.selectedDirectory;
    if (baseDir == null) return;

    if (context.mounted) {
      final Uri? newLocationUri = await showDialog<Uri>(
        context: context,
        builder: (BuildContext context) {
          return SelectLocationDialog(
            baseDir: baseDir,
            itemUris: itemUris,
          );
        },
      );

      if (newLocationUri != null) {
        if (itemUris.length == 1) {
          await StorageSystem.moveItem(itemUris.first, newLocationUri);
        } else {
          await StorageSystem.moveManyItems(itemUris, newLocationUri);
        }
        loadItems();
      }
    }
  }
}
