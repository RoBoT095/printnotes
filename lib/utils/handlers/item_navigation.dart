import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/view/screens/note_editor.dart';

class ItemNavHandler {
  static final List<String> _folderHistory = [];
  static String _selectedDirectory = '';

  static void initializeFolderHistory() async {
    final defaultPath = await DataPath.selectedDirectory;
    _selectedDirectory = defaultPath.toString();
  }

  // Let ItemNavHandler navigate folders instead

  static List<String> get folderHistory {
    if (_folderHistory.isEmpty) {
      _folderHistory.add(_selectedDirectory);
    }

    return _folderHistory;
  }

  // For notes only, won't work with folders
  static void onNoteSelect(
      BuildContext context, FileSystemEntity item, Function loadItems,
      {bool? latexSupport}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          filePath: item.path,
          latexSupport: latexSupport,
        ),
      ),
    ).then((value) => loadItems());
  }

  static Future<void> addToFolderHistory(String newPath,
      {List<String>? passHistory}) async {
    final history = passHistory ?? _folderHistory;
    if (history.isEmpty || history.last != newPath) {
      history.add(newPath);
    }
  }

  // Removes last entry in folder history then reloads items on page
  static String? navigateBack({List<String>? passHistory}) {
    final history = passHistory ?? _folderHistory;
    if (history.length > 1) {
      history.removeLast();
      String previousFolder = history.last;
      return previousFolder;
    }
    return null;
  }
}
