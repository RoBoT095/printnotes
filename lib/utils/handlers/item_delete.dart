import 'dart:io';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemDeletionHandler {
  static Future<void> showTrashConfirmation(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move To Trash?'),
        content: Text(
            'Are you sure you want to trash this ${item is Directory ? 'folder' : 'file'}?'),
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
              'Trash',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              handleItemTrashing(context, item, loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleItemTrashing(
      BuildContext context, FileSystemEntity item, Function loadItems,
      {int? daysForDeletion}) async {
    try {
      await StorageSystem.trashItem(item.path);

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
                'Error deleting ${item is Directory ? 'folder' : 'file'}: $e',
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
            'Are you sure you want to delete this ${item is Directory ? 'folder' : 'file'} forever?'),
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
      await StorageSystem.permanentlyDeleteItem(item.path);

      loadItems();
      if (context.mounted) {
        customSnackBar(
                '${item is Directory ? 'Folder' : 'File'} was permanently deleted',
                type: 'info')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar(
                'Error permanently deleting ${item is Directory ? 'folder' : 'file'}: $e',
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

  static Future<void> showTrashManyConfirmation(BuildContext context,
      List<FileSystemEntity> items, Function loadItems) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move All Trash?'),
        content: const Text(
            'Are you sure you want to move selected files to trash?'),
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
              'Trash All',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              handleManyItemTrashing(context, items, loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleManyItemTrashing(
      BuildContext context, List<FileSystemEntity> items, Function loadItems,
      {int? daysForDeletion}) async {
    try {
      for (var item in items) {
        await StorageSystem.trashItem(item.path);
      }

      loadItems();
      if (context.mounted) {
        customSnackBar('All items were moved to the trash bin', type: 'info')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar('Error deleting selected items: $e', type: 'error')
            .show(context);
      }
    }
  }
}
