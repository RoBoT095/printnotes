import 'dart:io';
import 'package:flutter/material.dart';

import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/ui/screens/notes/image_viewer.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/ui/screens/notes/note_editor.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ItemNavHandler {
  static final List<String> _mainFolderHistory = [];
  static String _selectedDirectory = '';

  static void initializeFolderHistory() async {
    final defaultPath = await DataPath.selectedDirectory;
    _selectedDirectory = defaultPath.toString();
  }

  // Let ItemNavHandler navigate folders instead

  static List<String> get folderHistory {
    if (_mainFolderHistory.isEmpty) {
      _mainFolderHistory.add(_selectedDirectory);
    }

    return _mainFolderHistory;
  }

  static void routeItemToPage(
      BuildContext context, FileSystemEntity item, Function loadItems,
      {List<String>? customDirHistory}) {
    if (item is File) {
      if (allowedImageExtensions.any((ext) => item.path.endsWith(ext))) {
        onImageSelect(context, item);
      } else if (allowedNoteExtensions.any((ext) => item.path.endsWith(ext))) {
        onNoteSelect(context, item, loadItems);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar('File format not supported!'));
      }
    }
  }

  // For notes only, won't work with folders
  static void onNoteSelect(
      BuildContext context, FileSystemEntity item, Function loadItems) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          filePath: item.path,
        ),
      ),
    ).then((value) => loadItems());
  }

  static void onImageSelect(
    BuildContext context,
    File item,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewScreen(imageFile: item)));
  }

  static Future<void> addToFolderHistory(String newPath,
      {List<String>? dirHistory}) async {
    final history = dirHistory ?? _mainFolderHistory;
    if (history.isEmpty || history.last != newPath) {
      history.add(newPath);
    }
  }

  // Removes last entry in folder history then reloads items on page
  static String? navigateBack({List<String>? dirHistory}) {
    final history = dirHistory ?? _mainFolderHistory;
    if (history.length > 1) {
      history.removeLast();
      String previousFolder = history.last;
      return previousFolder;
    }
    return null;
  }
}
