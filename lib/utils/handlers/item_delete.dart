import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemDeletionHandler {
  static Future<void> showDeleteConfirmation(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete this ${item is Directory ? 'folder' : 'note'} forever?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              handleItemDelete(context, item, loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleItemDelete(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    try {
      await StorageSystem.permanentlyDeleteItem(item.path);

      loadItems();
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            '${item is Directory ? 'Folder' : 'Note'} was permanently deleted'));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            'Error permanently deleting ${item is Directory ? 'folder' : 'note'}: $e'));
      }
    }
  }
}
