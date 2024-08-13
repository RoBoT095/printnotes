import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';

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
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Rename'),
            onPressed: () {
              Navigator.of(context).pop();
              handleItemRename(context, item,
                  controller.text.replaceAll('.md', ''), loadItems);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> handleItemRename(BuildContext context,
      FileSystemEntity item, String newName, Function loadItems) async {
    try {
      if (item is Directory) {
        await StorageSystem.renameFolder(item.path, newName);
      } else {
        await StorageSystem.renameNote(item.path, newName);
      }
      loadItems();
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${item is Directory ? 'Folder' : 'Note'} renamed successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error renaming ${item is Directory ? 'folder' : 'note'}: $e')),
        );
      }
    }
  }
}
