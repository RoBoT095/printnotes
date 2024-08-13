import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';

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
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Archive'),
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await StorageSystem.archiveItem(item.path);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${item is Directory ? 'Folder' : 'Note'} archived successfully')),
                  );
                }
                loadItems();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error archiving item: $e')),
                  );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item unarchived successfully')),
        );
      }
      loadItems();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error unarchiving item: $e')),
        );
      }
    }
  }
}
