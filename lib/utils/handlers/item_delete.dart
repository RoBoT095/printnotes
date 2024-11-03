import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';

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
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${item is Directory ? 'Folder' : 'Note'} was moved to the trash bin'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error deleting ${item is Directory ? 'folder' : 'note'}: $e')),
        );
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
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${item is Directory ? 'Folder' : 'Note'} was permanently deleted')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error permanently deleting ${item is Directory ? 'folder' : 'note'}: $e')),
        );
      }
    }
  }

  static Future<void> handleRestoringDeletedItem(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    try {
      await StorageSystem.restoreDeletedItem(item.path);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item was restored successfully')),
        );
      }
      loadItems();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error restoring deleted item: $e')),
        );
      }
    }
  }
}
