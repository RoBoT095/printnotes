import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

import 'package:printnotes/utils/handlers/item_navigation.dart';

Widget buildSearchResults(
    List<FileSystemEntity> searchResults, String? currentDirectory) {
  return ListView.builder(
    itemCount: searchResults.length,
    itemBuilder: (context, index) {
      final item = searchResults[index];
      final isDirectory = item is Directory;
      final itemPath = item.path;
      final relativePath = path.relative(itemPath, from: currentDirectory);
      return ListTile(
        leading: Icon(
          isDirectory ? Icons.folder : Icons.insert_drive_file,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(path.basename(itemPath)),
        subtitle: Text(relativePath),
        onTap: () {
          if (isDirectory) {
            // TODO: Add a way to navigate to folders
          } else {
            ItemNavHandler.handleNoteTap(context, item, () => currentDirectory);
          }
        },
      );
    },
  );
}
