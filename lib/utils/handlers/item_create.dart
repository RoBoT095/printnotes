import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemCreationHandler {
  static Future<void> handleCreateNewFolder(
    BuildContext context,
    String currentPath,
    Function loadItems,
  ) async {
    final dialogResult =
        await showNameInputDialog(context, 'Enter folder name');
    String folderName = dialogResult['name'];
    bool folderSubmitted = dialogResult['submitted'];
    if (folderSubmitted == true && folderName.isNotEmpty) {
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
    final dialogResult = await showNameInputDialog(context, 'Enter note name');
    String noteName = dialogResult['name'];
    bool noteSubmitted = dialogResult['submitted'];
    if (noteSubmitted == true && noteName.isNotEmpty) {
      try {
        final newNotePath =
            await StorageSystem.saveNote(noteName, '', parentPath: currentPath);
        if (context.mounted) {
          final item = File(newNotePath);
          ItemNavHandler.onNoteSelect(context, item, loadItems);
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

  static Future<Map<String, dynamic>> showNameInputDialog(
      BuildContext context, String title) async {
    String name = '';
    bool submitted = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          autofocus: true,
          onChanged: (value) {
            name = value;
          },
          onFieldSubmitted: (value) => Navigator.of(context).pop(value),
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
              onPressed: () {
                Navigator.of(context).pop(name);
                submitted = true;
              }),
        ],
      ),
    );
    return {
      'name': name,
      'submitted': submitted,
    };
  }
}
