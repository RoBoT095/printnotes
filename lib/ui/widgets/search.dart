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
      final itemPath = item.path;
      final relativePath = path.relative(itemPath, from: currentDirectory);
      return ListTile(
        leading: Icon(
          Icons.insert_drive_file,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(path.basename(itemPath)),
        subtitle: Text(relativePath),
        onTap: () {
          // Should never be a folder but it is just a backup check unless I messed something up
          if (item is File) {
            ItemNavHandler.onNoteSelect(context, item, () => currentDirectory);
          }
        },
      );
    },
  );
}
