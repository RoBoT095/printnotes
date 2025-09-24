import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemRenameHandler {
  static Future<void> showRenameDialog(
      BuildContext context, FileSystemEntity item) async {
    final TextEditingController controller = TextEditingController(
      text: item.path.split('/').last,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename ${item is Directory ? 'Folder' : 'File'}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
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
              'Rename',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              handleItemRename(context, item, controller.text);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleItemRename(
      BuildContext context, FileSystemEntity item, String newName,
      {bool? showMessage = true}) async {
    try {
      await StorageSystem.renameItem(item.uri, newName);
      if (context.mounted) {
        final readSettProv = context.read<SettingsProvider>();
        readSettProv.loadItems(context, readSettProv.currentPath);

        if (showMessage == true) {
          customSnackBar(
                  '${item is Directory ? 'Folder' : 'File'} renamed successfully',
                  type: 'success')
              .show(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        customSnackBar(
                'Error renaming ${item is Directory ? 'folder' : 'file'}: $e',
                type: 'error')
            .show(context);
      }
    }
  }
}
