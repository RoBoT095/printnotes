import 'dart:io';
import 'package:path/path.dart' as path;

class ItemSortHandler {
  static List<FileSystemEntity> sortItems(
      List<FileSystemEntity> items, String sortOrder) {
    switch (sortOrder) {
      case 'default':
        return items;
      case 'titleAsc':
        return items
          ..sort(
              (a, b) => path.basename(a.path).compareTo(path.basename(b.path)));
      case 'titleDsc':
        return items
          ..sort(
              (a, b) => path.basename(b.path).compareTo(path.basename(a.path)));
      default:
        return items;
    }
  }
}
