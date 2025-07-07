import 'dart:io';

import 'package:flutter/material.dart';

import 'package:printnotes/utils/storage_system.dart';

class SelectingProvider with ChangeNotifier {
  bool _selectingMode = false;
  final List<String> _selectedItems = [];

  bool get selectingMode => _selectingMode;
  List<String> get selectedItems => _selectedItems;

  void updateSelectedList(FileSystemEntity item) {
    if (_selectedItems.contains(item.path)) {
      _selectedItems.remove(item.path);
    } else {
      _selectedItems.add(item.path);
    }
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
        await StorageSystem.listFolderContents(dir);
    List<String> itemPathsList = [];
    for (FileSystemEntity item in items) {
      if (item is File) itemPathsList.add(item.path);
    }

    // If ALL already selected, then deselect all
    if (Set.of(_selectedItems).containsAll(itemPathsList)) {
      _selectedItems.clear();
    } else {
      // else select all
      for (String item in itemPathsList) {
        if (!_selectedItems.contains(item)) {
          _selectedItems.add(item);
        }
      }
    }
    notifyListeners();
  }
}
