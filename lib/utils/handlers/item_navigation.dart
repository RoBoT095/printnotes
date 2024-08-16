import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/view/screens/note_editor.dart';

class ItemNavHandler {
  // For notes only, won't work with folders
  static void handleNoteTap(
      BuildContext context, FileSystemEntity item, Function loadItems) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(filePath: item.path),
      ),
    ).then((value) => loadItems());
  }

  // Let ItemNavHandler navigate folders instead

  static Future<void> updateFolderHistory(
      String newPath, List<String> folderHistory) async {
    if (folderHistory.isEmpty || folderHistory.last != newPath) {
      folderHistory.add(newPath);
    }
  }

  // Removes last entry in folder history then reloads items on page
  static Future<void> navigateBack(
      List<String> folderHistory, Function loadItems) async {
    if (folderHistory.length > 1) {
      folderHistory.removeLast();
      String previousFolder = folderHistory.last;
      loadItems(previousFolder);
    }
  }
}
