import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemDuplicationHandler {
  final BuildContext context;

  ItemDuplicationHandler(this.context);

  Future<void> handleDuplicateItem(
    FileSystemEntity item,
    Function loadItems,
  ) async {
    // Fallback in case user somehow tries to duplicate a folder
    if (item is! File) {
      customSnackBar('Only files can be duplicated.', type: 'warning')
          .show(context);
      return;
    }

    try {
      final newPath = await StorageSystem.duplicateItem(item.path);
      final newFileName = path.basename(newPath);

      loadItems();

      if (context.mounted) {
        customSnackBar('file duplicated: $newFileName', type: 'success')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar('Error duplicating file: $e', type: 'error')
            .show(context);
      }
    }
  }
}
