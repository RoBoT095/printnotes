import 'dart:io';

import 'package:flutter/material.dart';

import 'package:printnotes/utils/storage_system.dart';

class SelectingProvider with ChangeNotifier {
  bool _selectingMode = false;
  final List<String> _selectedItems = [];

  bool get selectingMode => _selectingMode;
  List<String> get selectedItems => _selectedItems;

  void updateSelectedList(FileSystemEntity item) {
    final path = item.path;

    _selectedItems.contains(path)
        ? _selectedItems.remove(path)
        : _selectedItems.add(path);

    notifyListeners();
  }

  void setSelectingMode({bool? mode}) {
    if (mode != null) {
      _selectingMode = mode;
      if (!mode) _selectedItems.clear();
    } else {
      _selectingMode = !_selectingMode;
    }
    notifyListeners();
  }

  Future<void> selectAll(String dir) async {
    final List<FileSystemEntity> items =
        await StorageSystem.listFolderContents(Uri.parse(dir));

    final filePaths = items.whereType<File>().map((file) => file.path).toList();

    // If ALL already selected, then deselect all
    if (_selectedItems.toSet().containsAll(filePaths)) {
      _selectedItems.clear();
    } else {
      // else select all
      final missing = filePaths.where((path) => !_selectedItems.contains(path));
      _selectedItems.addAll(missing);
    }
    notifyListeners();
  }
}
