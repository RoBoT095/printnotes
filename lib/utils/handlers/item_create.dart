import 'package:flutter/material.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/view/components/widgets/custom_snackbar.dart';

class ItemCreationHandler {
  static Future<void> handleCreateNewFolder(
    BuildContext context,
    String currentPath,
    Function loadItems,
  ) async {
    final folderName = await showNameInputDialog(context, 'Enter folder name');
    if (folderName != null && folderName.isNotEmpty) {
      try {
        final newFolderPath = await StorageSystem.createFolder(folderName,
            parentPath: currentPath);
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(customSnackBar('Folder created: $newFolderPath'));
        }
        loadItems();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(customSnackBar('Error creating folder: $e'));
        }
      }
    }
  }

  static Future<void> handleCreateNewNote(
    BuildContext context,
    String currentPath,
    Function loadItems,
  ) async {
    final noteName = await showNameInputDialog(context, 'Enter note name');
    if (noteName != null && noteName.isNotEmpty) {
      try {
        final newNotePath =
            await StorageSystem.saveNote(noteName, '', parentPath: currentPath);
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(customSnackBar('Note created: $newNotePath'));
        }
        loadItems();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(customSnackBar('Error creating note: $e'));
        }
      }
    }
  }

  static Future<String?> showNameInputDialog(
      BuildContext context, String title) async {
    String? name;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            name = value;
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(name),
          ),
        ],
      ),
    );
    return name;
  }
}
