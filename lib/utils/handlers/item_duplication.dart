import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:printnotes/utils/storage_system.dart';

class ItemDuplicationHandler {
  static Future<void> handleDuplicateItem(
    BuildContext context,
    FileSystemEntity item,
    Function loadItems,
  ) async {
    // Fallback in case user somehow tries to duplicate a folder
    if (item is! File) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only files can be duplicated.')),
      );
      return;
    }

    try {
      final newPath = await StorageSystem.duplicateNote(item.path);
      final newFileName = path.basename(newPath);

      loadItems();

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note duplicated: $newFileName')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error duplicating note: $e')),
        );
      }
    }
  }
}
