import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemCreationHandler {
  final BuildContext context;

  ItemCreationHandler(this.context);

  Future<void> handleCreateNewFolder(String currentPath) async {
    final dialogResult = await showNameInputDialog('Enter folder name');
    String folderName = dialogResult['name'];
    bool folderSubmitted = dialogResult['submitted'];
    if (folderSubmitted == true && folderName.isNotEmpty) {
      try {
        final newFolderPath = await StorageSystem.createFolder(folderName,
            parentPath: currentPath);
        final selectedDir = await DataPath.selectedDirectory;
        if (context.mounted) {
          final readSettProv = context.read<SettingsProvider>();
          readSettProv.loadItems(context, readSettProv.currentPath);

          customSnackBar(
                  'Folder created: ${path.relative(newFolderPath, from: selectedDir)}',
                  type: 'success')
              .show(context);
        }
      } catch (e) {
        if (context.mounted) {
          customSnackBar('Error creating folder: $e', type: 'error')
              .show(context);
        }
      }
    }
  }

  Future<void> handleCreateNewNote(String currentPath) async {
    final dialogResult = await showNameInputDialog('Enter note name');
    String noteName = dialogResult['name'];
    bool noteSubmitted = dialogResult['submitted'];
    if (noteSubmitted && noteName.isNotEmpty) {
      try {
        debugPrint('Create note: $noteName $currentPath');
        await StorageSystem.createFile(noteName, parentPath: currentPath)
            .then((e) {
          if (context.mounted) {
            final readSettProv = context.read<SettingsProvider>();
            readSettProv.loadItems(context, readSettProv.currentPath);

            context
                .read<NavigationProvider>()
                .routeItemToPage(context, File(e).uri);
          }
        });
      } catch (e) {
        if (context.mounted) {
          customSnackBar('Error creating note: $e', type: 'error')
              .show(context);
        }
      }
    }
  }

  Future<void> handleCreateNewSketch(
    String currentPath,
  ) async {
    final dialogResult = await showNameInputDialog('Enter sketch name');
    String sketchName = dialogResult['name'];
    bool noteSubmitted = dialogResult['submitted'];
    if (noteSubmitted && sketchName.isNotEmpty) {
      try {
        await StorageSystem.createFile('$sketchName.bson',
                parentPath: currentPath)
            .then((e) {
          if (context.mounted) {
            final readSettProv = context.read<SettingsProvider>();
            readSettProv.loadItems(context, readSettProv.currentPath);
            context
                .read<NavigationProvider>()
                .routeItemToPage(context, File(e).uri);
          }
        });
      } catch (e) {
        if (context.mounted) {
          customSnackBar('Error creating sketch file: $e', type: 'error')
              .show(context);
        }
      }
    }
  }

  Future<Map<String, dynamic>> showNameInputDialog(String title) async {
    String? name;
    bool submitted = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          autofocus: true,
          onChanged: (value) => name = value,
          onFieldSubmitted: (value) {
            Navigator.of(context).pop(value);
            submitted = true;
          },
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
                'OK',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
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
