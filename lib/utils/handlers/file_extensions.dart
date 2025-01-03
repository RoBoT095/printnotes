import 'dart:io';
import 'package:printnotes/constants/constants.dart';

enum CFileType {
  note,
  image,
  pdf,
  unknown,
}

CFileType fileTypeChecker(FileSystemEntity file) {
  if (allowedNoteExtensions.any((ext) => file.path.endsWith(ext))) {
    return CFileType.note;
  } else if (allowedImageExtensions.any((ext) => file.path.endsWith(ext))) {
    return CFileType.image;
  } else if (allowedPdfExtensions.any((ext) => file.path.endsWith(ext))) {
    return CFileType.pdf;
  } else {
    return CFileType.unknown;
  }
}
