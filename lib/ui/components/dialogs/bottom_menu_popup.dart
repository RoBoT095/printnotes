import 'dart:io';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/handlers/item_move.dart';
import 'package:printnotes/utils/handlers/item_rename.dart';
import 'package:printnotes/utils/handlers/item_duplication.dart';
import 'package:printnotes/utils/handlers/item_archive.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';

void showBottomMenu(
  BuildContext context,
  FileSystemEntity item,
  Function loadItems,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.drive_file_move_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Move'),
              onTap: () {
                Navigator.pop(context);
                ItemMoveHandler.showMoveDialog(context, item, loadItems);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                ItemRenameHandler.showRenameDialog(context, item, loadItems);
              },
            ),
            if (item is! Directory)
              ListTile(
                leading: Icon(
                  Icons.copy,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(context);
                  ItemDuplicationHandler.handleDuplicateItem(
                      context, item, loadItems);
                },
              ),
            ListTile(
              leading: Icon(
                Icons.archive_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                ItemArchiveHandler.handleArchiveItem(context, item, loadItems);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_sweep,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('To Trash'),
              onTap: () {
                Navigator.pop(context);
                ItemDeletionHandler.showSoftDeleteConfirmation(
                    context, item, loadItems);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                ItemDeletionHandler.showPermanentDeleteConfirmation(
                    context, item, loadItems);
              },
            ),
          ],
        ),
      );
    },
  );
}
