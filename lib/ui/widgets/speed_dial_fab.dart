import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/item_create.dart';

Widget speedDialFAB(BuildContext context, {required VoidCallback onLoadItems}) {
  return SpeedDial(
    icon: Icons.add,
    activeIcon: Icons.close,
    childPadding: const EdgeInsets.all(5),
    spaceBetweenChildren: 10,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.create_new_folder_outlined),
        label: 'Create Folder',
        onTap: () => ItemCreationHandler.handleCreateNewFolder(
          context,
          context.watch<SettingsProvider>().mainDir,
          () => onLoadItems(),
        ),
      ),
      SpeedDialChild(
        child: const Icon(Icons.note_add_outlined),
        label: 'Create Note',
        onTap: () => ItemCreationHandler.handleCreateNewNote(
          context,
          context.watch<SettingsProvider>().mainDir,
          () => onLoadItems(),
        ),
      ),
      SpeedDialChild(
        child: const Icon(Icons.folder_copy),
        label: 'Open External File',
        onTap: () =>
            ItemNavHandler.openExternalFile(context, () => onLoadItems()),
      )
    ],
  );
}
