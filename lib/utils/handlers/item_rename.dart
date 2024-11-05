import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemRenameHandler {
  static Future<void> showRenameDialog(
      BuildContext context, FileSystemEntity item, Function loadItems) async {
    final TextEditingController controller = TextEditingController(
      text: item.path.split('/').last,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename ${item is Directory ? 'Folder' : 'Note'}'),
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
              handleItemRename(context, item, controller.text,
                  reload: loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleItemRename(
      BuildContext context, FileSystemEntity item, String newName,
      {Function? reload, bool? showMessage = true}) async {
    try {
      await StorageSystem.renameItem(item.path, newName);
      if (reload != null) reload();
      if (context.mounted && showMessage == true) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            '${item is Directory ? 'Folder' : 'File'} renamed successfully'));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            'Error renaming ${item is Directory ? 'folder' : 'note'}: $e'));
      }
    }
  }
}
