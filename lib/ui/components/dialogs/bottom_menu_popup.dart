import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';

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
      bool isTreeView = context.read<SettingsProvider>().layout == 'tree';
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (item is! Directory)
              ListTile(
                textColor: isTreeView ? Theme.of(context).disabledColor : null,
                iconColor: isTreeView
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.check),
                title: const Text('Select'),
                onTap: isTreeView
                    ? null
                    : () {
                        Navigator.pop(context);
                        context
                            .read<SelectingProvider>()
                            .setSelectingMode(mode: true);
                        context
                            .read<SelectingProvider>()
                            .updateSelectedList(item);
                      },
              ),
            ListTile(
              leading: Icon(
                Icons.drive_file_move_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Move'),
              onTap: () {
                Navigator.pop(context);
                ItemMoveHandler.showMoveDialog(context, [item.uri], loadItems);
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
                ItemRenameHandler.showRenameDialog(context, item);
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
                  ItemDuplicationHandler(context).handleDuplicateItem(item);
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
                ItemArchiveHandler(context).handleArchiveItem(item);
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
                ItemDeletionHandler(context)
                    .showTrashConfirmation(item, loadItems);
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
                ItemDeletionHandler(context)
                    .showPermanentDeleteConfirmation(item, loadItems);
              },
            ),
          ],
        ),
      );
    },
  );
}
