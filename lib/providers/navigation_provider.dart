import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/ui/screens/notes/image_viewer.dart';
import 'package:printnotes/ui/screens/notes/note_editor.dart';
import 'package:printnotes/ui/screens/notes/pdf_viewer.dart';
// import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class NavigationProvider with ChangeNotifier {
  final List<String> _routeHistory = [];

  List<String> get routeHistory => _routeHistory;

  void initRouteHistory(String initDir) {
    if (_routeHistory.isEmpty) {
      _routeHistory.add(initDir);
    } else if (_routeHistory.first != initDir) {
      _routeHistory.clear();
      _routeHistory.add(initDir);
    }
  }

  void addToRouteHistory(String route) {
    // if main route was passed, reset history to main route
    if (_routeHistory.first == route) {
      _routeHistory.clear();
      _routeHistory.add(route);
      notifyListeners();
    }
    // Prevent the addition of the same route to list again
    if (_routeHistory.last != route) {
      _routeHistory.add(route);
    }
  }

  // Removes last entry in folder history and return path of previous location
  String? navigateBack() {
    if (_routeHistory.length > 1) {
      _routeHistory.removeLast();
      notifyListeners();
      return _routeHistory.last;
    }

    return null;
  }

  void routeItemToPage(BuildContext context, FileSystemEntity item) {
    if (item is File) {
      if (fileTypeChecker(item) == CFileType.image) {
        onImageSelect(context, item);
      } else if (fileTypeChecker(item) == CFileType.pdf) {
        onPdfSelect(context, item);
      } else {
        onNoteSelect(context, item);
      }
    }
  }

  // For notes only, won't work with folders
  void onNoteSelect(
    BuildContext context,
    File item,
  ) {
    addToRouteHistory(item.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          filePath: item.path,
        ),
      ),
    ).then((_) => navigateBack());
  }

  void onImageSelect(
    BuildContext context,
    File item,
  ) {
    addToRouteHistory(item.path);
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageViewScreen(imageFile: item)))
        .then((_) => navigateBack());
  }

  void onPdfSelect(
    BuildContext context,
    File item,
  ) {
    addToRouteHistory(item.path);
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfViewScreen(pdfFile: item)))
        .then((_) => navigateBack());
  }

  // Open files outside selected app directory
  Future<void> openExternalFile(BuildContext context) async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (selectedFile != null && context.mounted) {
      File item = File(selectedFile.files.single.path!);
      routeItemToPage(context, item);
    }
  }
}
