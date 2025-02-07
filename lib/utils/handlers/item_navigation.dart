import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/ui/screens/notes/note_editor.dart';
import 'package:printnotes/ui/screens/notes/image_viewer.dart';
import 'package:printnotes/ui/screens/notes/pdf_viewer.dart';
// import 'package:printnotes/ui/widgets/custom_snackbar.dart';

// TODO: Move to NavigationProvider
class ItemNavHandler {
  static final List<String> _handlersFolderHistory = [];

  // Let ItemNavHandler navigate folders instead

  static List<String> folderHistory(String? initializingDir) {
    if (initializingDir != null) {
      if (_handlersFolderHistory.isEmpty) {
        _handlersFolderHistory.add(initializingDir);
      } else if (_handlersFolderHistory.first != initializingDir) {
        _handlersFolderHistory.clear();
        _handlersFolderHistory.add(initializingDir);
      }
    }
    return _handlersFolderHistory;
  }

  static void routeItemToPage(
      BuildContext context, FileSystemEntity item, Function loadItems,
      {List<String>? customDirHistory}) {
    if (item is File) {
      if (fileTypeChecker(item) == CFileType.note) {
        onNoteSelect(context, item, loadItems);
      } else if (fileTypeChecker(item) == CFileType.image) {
        onImageSelect(context, item);
      } else if (fileTypeChecker(item) == CFileType.pdf) {
        onPdfSelect(context, item);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Not Supported File Format')));

        // Does not appear unless UI is updated, will fix later

        // customSnackBar('File format not supported!', type: 'info')
        //     .show(context);
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

  static void onPdfSelect(
    BuildContext context,
    File item,
  ) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PdfViewScreen(pdfFile: item)));
  }

  static Future<void> addToFolderHistory(String newPath,
      {List<String>? dirHistory}) async {
    final history = dirHistory ?? _handlersFolderHistory;
    if (history.isEmpty || history.last != newPath) {
      history.add(newPath);
    }
  }

  // Removes last entry in folder history then reloads items on page
  static String? navigateBack({List<String>? dirHistory}) {
    final history = dirHistory ?? _handlersFolderHistory;
    if (history.length > 1) {
      history.removeLast();
      return history.last;
    }
    return null;
  }

  // Open files outside selected app directory
  static Future<void> openExternalFile(
      BuildContext context, Function loadItems) async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (selectedFile != null && context.mounted) {
      File item = File(selectedFile.files.single.path!);
      routeItemToPage(context, item, loadItems);
    }
  }
}
