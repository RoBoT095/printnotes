import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemArchiveHandler {
  final BuildContext context;

  ItemArchiveHandler(this.context);

  Future<void> handleArchiveItem(FileSystemEntity item) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Archive'),
        content: Text(
            'Are you sure you want to archive this ${item is Directory ? 'folder' : 'file'}? It will be removed from its current location.'),
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
                await StorageSystem.archiveItem(item.uri);
                if (context.mounted) {
                  final readSettProv = context.read<SettingsProvider>();
                  readSettProv.loadItems(context, readSettProv.currentPath);

                  customSnackBar(
                          '${item is Directory ? 'Folder' : 'File'} archived successfully',
                          type: 'success')
                      .show(context);
                }
              } catch (e) {
                if (context.mounted) {
                  customSnackBar('Error archiving item: $e', type: 'error')
                      .show(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> handleUnarchiveItem(
      FileSystemEntity item, Function loadItems) async {
    try {
      await StorageSystem.unarchiveItem(item.path);
      if (context.mounted) {
        customSnackBar('Item unarchived successfully', type: 'success')
            .show(context);
      }
      loadItems();
    } catch (e) {
      if (context.mounted) {
        customSnackBar('Error unarchiving item: $e', type: 'error')
            .show(context);
      }
    }
  }
}
