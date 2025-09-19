import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/utils/handlers/item_create.dart';

Widget speedDialFAB(
    BuildContext context, String currentFolder, Function loadItems) {
  return SpeedDial(
    icon: Icons.add,
    activeIcon: Icons.close,
    childPadding: const EdgeInsets.all(5),
    spaceBetweenChildren: 10,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.create_new_folder_outlined),
        label: 'Create Folder',
        onTap: () async => await ItemCreationHandler.handleCreateNewFolder(
            context, currentFolder, loadItems),
      ),
      SpeedDialChild(
        child: const Icon(Icons.note_add_outlined),
        label: 'Create Note',
        onTap: () async => await ItemCreationHandler.handleCreateNewNote(
            context, currentFolder, loadItems),
      ),
      SpeedDialChild(
        child: const Icon(Icons.draw),
        label: 'Create Sketch',
        onTap: () async => await ItemCreationHandler.handleCreateNewSketch(
            context, currentFolder, loadItems),
      ),
      SpeedDialChild(
        child: const Icon(Icons.folder_copy),
        label: 'Open External File',
        onTap: () async =>
            await context.read<NavigationProvider>().openExternalFile(context),
      )
    ],
  );
}
