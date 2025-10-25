import 'package:path/path.dart' as path;
import 'package:printnotes/constants/constants.dart';

enum CFileType {
  note,
  image,
  pdf,
  sketch,
  unknown,
}

CFileType fileTypeChecker(String itemPath) {
  String extension = path.extension(itemPath);
  if (allowedNoteExtensions.any((ext) => ext == extension)) {
    return CFileType.note;
  } else if (allowedImageExtensions.any((ext) => ext == extension)) {
    return CFileType.image;
  } else if (allowedPdfExtensions.any((ext) => ext == extension)) {
    return CFileType.pdf;
  } else if (allowedSketchExtensions.any((ext) => ext == extension)) {
    return CFileType.sketch;
  } else {
    return CFileType.unknown;
  }
}
