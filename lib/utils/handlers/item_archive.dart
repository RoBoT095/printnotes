import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemArchiveHandler {
  static Future<void> handleArchiveItem(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Archive'),
        content: Text(
            'Are you sure you want to archive this ${item is Directory ? 'folder' : 'note'}? It will be removed from its current location.'),
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
              'Archive',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await StorageSystem.archiveItem(item.path);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      '${item is Directory ? 'Folder' : 'Note'} archived successfully'));
                }
                loadItems();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(customSnackBar('Error archiving item: $e'));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleUnarchiveItem(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    try {
      await StorageSystem.unarchiveItem(item.path);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar('Item unarchived successfully'));
      }
      loadItems();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar('Error unarchiving item: $e'));
      }
    }
  }
}
