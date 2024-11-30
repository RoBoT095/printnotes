import 'dart:io';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemDeletionHandler {
  static Future<void> showSoftDeleteConfirmation(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move To Trash?'),
        content: Text(
            'Are you sure you want to delete this ${item is Directory ? 'folder' : 'note'}?'),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              handleSoftItemDelete(context, item, loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleSoftItemDelete(
      BuildContext context, FileSystemEntity item, Function loadItems,
      {int? daysForDeletion}) async {
    try {
      await StorageSystem.softDeleteItem(item.path);

      loadItems();
      if (context.mounted) {
        customSnackBar(
                '${item is Directory ? 'Folder' : 'Note'} was moved to the trash bin',
                type: 'info')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar(
                'Error deleting ${item is Directory ? 'folder' : 'note'}: $e',
                type: 'error')
            .show(context);
      }
    }
  }

  static Future<void> showPermanentDeleteConfirmation(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Permanent Deletion'),
        content: Text(
            'Are you sure you want to delete this ${item is Directory ? 'folder' : 'note'} forever?'),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              handlePermanentItemDelete(context, item, loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handlePermanentItemDelete(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    try {
      await StorageSystem.softDeleteItem(item.path);

      loadItems();
      if (context.mounted) {
        customSnackBar(
                '${item is Directory ? 'Folder' : 'Note'} was permanently deleted',
                type: 'info')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar(
                'Error permanently deleting ${item is Directory ? 'folder' : 'note'}: $e',
                type: 'error')
            .show(context);
      }
    }
  }

  static Future<void> handleRestoringDeletedItem(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    try {
      await StorageSystem.restoreDeletedItem(item.path);
      if (context.mounted) {
        customSnackBar('Item was restored successfully', type: 'success')
            .show(context);
      }
      loadItems();
    } catch (e) {
      if (context.mounted) {
        customSnackBar('Error restoring deleted item: $e', type: 'error')
            .show(context);
      }
    }
  }
}
