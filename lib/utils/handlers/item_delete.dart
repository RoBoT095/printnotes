import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemDeletionHandler {
  final BuildContext context;

  ItemDeletionHandler(this.context);

  Future<void> showTrashConfirmation(FileSystemEntity item,
      {VoidCallback? onComplete}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move To Trash?'),
        content: Text(
            'Are you sure you want to trash "${path.basename(item.path)}"${item is Directory ? " folder" : ""}?'),
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
              handleItemTrashing(item, onComplete: onComplete);
            },
          ),
        ],
      ),
    );
  }

  Future<void> handleItemTrashing(FileSystemEntity item,
      {VoidCallback? onComplete}) async {
    try {
      await StorageSystem.trashItem(item.path);

      if (context.mounted) {
        final readSettProv = context.read<SettingsProvider>();
        readSettProv.loadItems(readSettProv.currentPath);

        onComplete?.call();

        customSnackBar(
                '"${path.basename(item.path)}"${item is Directory ? " folder" : ""} was moved to the trash bin',
                type: 'info')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar('Error deleting "${path.basename(item.path)}": $e',
                type: 'error')
            .show(context);
      }
    }
  }

  Future<void> showPermanentDeleteConfirmation(FileSystemEntity item,
      {VoidCallback? onComplete}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete "${path.basename(item.path)}"${item is Directory ? " folder" : ""} forever?'),
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
              handlePermanentItemDelete(item, onComplete: onComplete);
            },
          ),
        ],
      ),
    );
  }

  Future<void> handlePermanentItemDelete(FileSystemEntity item,
      {VoidCallback? onComplete}) async {
    try {
      await StorageSystem.permanentlyDeleteItem(item.path);

      if (context.mounted) {
        final readSettProv = context.read<SettingsProvider>();
        readSettProv.loadItems(readSettProv.currentPath);

        onComplete?.call();

        customSnackBar(
                '"${path.basename(item.path)}"${item is Directory ? " folder" : ""} was deleted',
                type: 'info')
            .show(context);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar(
                'Error permanently deleting "${path.basename(item.path)}"${item is Directory ? " folder" : ""}: $e',
                type: 'error')
            .show(context);
      }
    }
  }

  Future<void> handleRestoringDeletedItem(FileSystemEntity item,
      {VoidCallback? onComplete}) async {
    try {
      await StorageSystem.restoreDeletedItem(item.path);
      if (context.mounted) {
        customSnackBar(
                '"${path.basename(item.path)}"${item is Directory ? " folder" : ""} was restored successfully',
                type: 'success')
            .show(context);

        onComplete?.call();

        final readSettProv = context.read<SettingsProvider>();
        readSettProv.loadItems(readSettProv.currentPath);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar(
                'Error restoring deleted "${path.basename(item.path)}"${item is Directory ? " folder" : ""}: $e',
                type: 'error')
            .show(context);
      }
    }
  }

  Future<void> showTrashManyConfirmation(List<FileSystemEntity> items,
      {VoidCallback? onComplete}) async {
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
              handleManyItemTrashing(items, onComplete: onComplete);
            },
          ),
        ],
      ),
    );
  }

  Future<void> handleManyItemTrashing(List<FileSystemEntity> items,
      {VoidCallback? onComplete}) async {
    try {
      for (FileSystemEntity item in items) {
        await StorageSystem.trashItem(item.path);
      }

      if (context.mounted) {
        final readSettProv = context.read<SettingsProvider>();
        readSettProv.loadItems(readSettProv.currentPath);

        onComplete?.call();

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
