import 'dart:io';
import 'package:printnotes/constants/constants.dart';

enum FileType {
  note,
  image,
  pdf,
  unknown,
}

FileType fileTypeChecker(FileSystemEntity file) {
  if (allowedNoteExtensions.any((ext) => file.path.endsWith(ext))) {
    return FileType.note;
  } else if (allowedImageExtensions.any((ext) => file.path.endsWith(ext))) {
    return FileType.image;
  } else if (allowedPdfExtensions.any((ext) => file.path.endsWith(ext))) {
    return FileType.pdf;
  } else {
    return FileType.unknown;
  }
}
