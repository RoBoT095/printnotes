import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/ui/screens/editors/sketch_pad/sketch_pad.dart';

import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/ui/screens/viewers/image_viewer.dart';
import 'package:printnotes/ui/screens/editors/notes/note_editor.dart';
import 'package:printnotes/ui/screens/viewers/pdf_viewer.dart';

class NavigationProvider with ChangeNotifier {
  final List<String> _routeHistory = [];

  List<String> get routeHistory => _routeHistory;

  void initRouteHistory(String initDir) {
    if (_routeHistory.isEmpty || _routeHistory.first != initDir) {
      _routeHistory.clear();
      _routeHistory.add(initDir);
    }
    debugPrint('RouteHistory init: $_routeHistory');
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
    debugPrint('RouteHistory add: $_routeHistory');
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

  void routeItemToPage(BuildContext context, Uri item,
      {String? jumpToHeader}) async {
    Future.delayed(const Duration(milliseconds: 50), () async {
      bool fileExists = await File.fromUri(item).exists();
      if (fileExists && context.mounted) {
        if (fileTypeChecker(item.path) == CFileType.image) {
          _openPage(context, item, () => ImageViewScreen(imageUri: item));
        } else if (fileTypeChecker(item.path) == CFileType.pdf) {
          _openPage(context, item, () => PdfViewScreen(pdfUri: item));
        } else if (fileTypeChecker(item.path) == CFileType.sketch) {
          _openPage(context, item, () => SketchPad(sketchUri: item));
        } else {
          _openPage(
            context,
            item,
            () => NoteEditorScreen(fileUri: item, jumpToHeader: jumpToHeader),
          );
        }
      } else {
        debugPrint(
            'NavigationProvider routeItemToPage: Item doesn\'t exist or isn\'t a File');
      }
    });
  }

  void _openPage(BuildContext context, Uri uri, Widget Function() page) async {
    addToRouteHistory(uri.path);
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => page()))
        .then((_) => navigateBack());
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
      routeItemToPage(context, item.uri);
    }
  }
}
