import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:printnotes/constants/toolbar_items_list.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class EditorConfigProvider with ChangeNotifier {
  double _fontSize = 16;
  bool _isEditing = true;
  List<ToolbarConfigItem> _toolbarItemList = [];

  double get fontSize => _fontSize;
  bool get isEditing => _isEditing;
  List<ToolbarConfigItem> get toolbarItemList => _toolbarItemList;

  EditorConfigProvider() {
    loadEditorConfig();
  }

  void loadEditorConfig() async {
    final fontSize = await UserEditorConfig.getFontSize();
    final toolbarConfig = await UserEditorConfig.getToolbarConfig();

    setFontSize(fontSize);
    setToolbarConfig(toolbarConfig);
  }

  void setFontSize(double fontSize) {
    _fontSize = fontSize;
    UserEditorConfig.setFontSize(fontSize);
    notifyListeners();
  }

  void setIsEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void setToolbarConfig(String? config) {
    if (config == null || config.isEmpty) {
      _toolbarItemList = defaultToolbarList;
    } else {
      List<ToolbarConfigItem> decodedJsonList = (jsonDecode(config) as List)
          .map((e) => ToolbarConfigItem.fromJson(e))
          .toList();
      _toolbarItemList = decodedJsonList;
    }
    String encodedList =
        jsonEncode(_toolbarItemList.map((e) => e.toJson()).toList());
    UserEditorConfig.setToolbarConfig(encodedList);
    notifyListeners();
  }

  void setToolbarItemVisibility() {} // TODO

  void updateListOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final toolbarItem = _toolbarItemList.removeAt(oldIndex);
    _toolbarItemList.insert(newIndex, toolbarItem);

    String encodedList =
        jsonEncode(_toolbarItemList.map((e) => e.toJson()).toList());
    UserEditorConfig.setToolbarConfig(encodedList);
    notifyListeners();
  }
}
