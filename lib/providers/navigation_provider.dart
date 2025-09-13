import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/ui/screens/editors/sketch_pad/sketch_pad.dart';

import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/ui/screens/viewers/image_viewer.dart';
import 'package:printnotes/ui/screens/editors/notes/note_editor.dart';
import 'package:printnotes/ui/screens/viewers/pdf_viewer.dart';
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

  void routeItemToPage(BuildContext context, FileSystemEntity item,
      {String? jumpToHeader}) {
    if (item is File) {
      if (fileTypeChecker(item) == CFileType.image) {
        onImageSelect(context, item);
      } else if (fileTypeChecker(item) == CFileType.pdf) {
        onPdfSelect(context, item);
      } else if (fileTypeChecker(item) == CFileType.sketch) {
        onSketchSelect(context, item);
      } else {
        onNoteSelect(context, item, jumpToHeader: jumpToHeader);
      }
    }
  }

  // For notes only, won't work with folders
  void onNoteSelect(BuildContext context, File item, {String? jumpToHeader}) {
    addToRouteHistory(item.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          filePath: item.path,
          jumpToHeader: jumpToHeader,
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

  void onSketchSelect(BuildContext context, File item) {
    addToRouteHistory(item.path);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SketchPad(sketchFile: item),
        )).then((_) => navigateBack());
  }

  // Open files outside selected app directory
  Future<void> openExternalFile(BuildContext context) async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        ...allowedImageExtensions,
        ...allowedPdfExtensions,
        ...allowedNoteExtensions,
      ],
    );
    if (selectedFile != null && context.mounted) {
      File item = File(selectedFile.files.single.path!);
      routeItemToPage(context, item);
    }
  }
}
