import 'dart:io';
import 'package:path/path.dart' as path;

class ItemSortHandler {
  final String sortOrder;
  final String folderPriority;

  ItemSortHandler(this.sortOrder, this.folderPriority);

  List<FileSystemEntity> getSortedItems(List<FileSystemEntity> items) {
    return _folderPrioritySort(items, folderPriority, sortOrder);
  }

  List<FileSystemEntity> _folderPrioritySort(
      List<FileSystemEntity> items, String folderPriority, String sortOrder) {
    List<FileSystemEntity> folders = [];
    List<FileSystemEntity> files = [];

    for (FileSystemEntity item in items) {
      if (item is Directory) {
        folders.add(item);
      } else {
        files.add(item);
      }
    }

    folders = _sortItems(folders);
    files = _sortItems(files);

    switch (folderPriority) {
      case 'above':
        return [...folders, ...files];
      case 'below':
        return [...files, ...folders];
      default:
        return _sortItems(items);
    }
  }

  List<FileSystemEntity> _sortItems(List<FileSystemEntity> items) {
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
      case 'lastModAsc':
        return items
          ..sort(
            (a, b) => a.statSync().modified.compareTo(b.statSync().modified),
          );
      case 'lastModDsc':
        return items
          ..sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
          );
      default:
        return items;
    }
  }
}
