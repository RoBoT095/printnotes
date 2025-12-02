import 'package:flutter/material.dart';

import 'package:printnotes/constants/toolbar_items_list.dart';
import 'package:printnotes/utils/config_file/toolbar_config_handler.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class EditorConfigProvider with ChangeNotifier {
  double _fontSize = 16;
  bool _defaultEditorMode = false;
  bool _isEditing = false;
  List<ToolbarConfigItem> _toolbarItemList = [];

  double get fontSize => _fontSize;
  bool get defaultEditorMode => _defaultEditorMode;
  bool get isEditing => _isEditing;
  List<ToolbarConfigItem> get toolbarItemList => _toolbarItemList;

  EditorConfigProvider() {
    loadEditorConfig();
  }

  void loadEditorConfig() {
    final toolbarConfig = loadToolbarLoadout();

    _toolbarItemList = toolbarConfig ?? List.from(defaultToolbarList);
    _fontSize = UserEditorConfig.getFontSize();
    _defaultEditorMode = UserEditorConfig.getDefaultEditorMode();

    notifyListeners();
  }

  void setFontSize(double fontSize) {
    _fontSize = fontSize;
    UserEditorConfig.setFontSize(fontSize);
    notifyListeners();
  }

  void setAutoEditMode(bool setMode) {
    _defaultEditorMode = setMode;
    UserEditorConfig.setDefaultEditorMode(setMode);
    notifyListeners();
  }

  void setIsEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void setToolbarConfig(List<ToolbarConfigItem>? configList) {
    if (configList == null || configList.isEmpty) {
      _toolbarItemList = defaultToolbarList;
    } else if (configList.length > defaultToolbarList.length) {
      // Remove toolbar items if they don't exist in default list
      configList.removeWhere((item) => !defaultToolbarList.contains(item));
    } else if (configList.length < defaultToolbarList.length) {
      // If default list longer than config list, add to it
      for (ToolbarConfigItem item in defaultToolbarList) {
        if (!configList.contains(item)) {
          debugPrint('Added $item from Toolbar configList');
          configList.add(item);
        }
      }
    } else {
      _toolbarItemList = configList;
    }
    saveToolbarLoadout(_toolbarItemList);
    notifyListeners();
  }

  void setToolbarItemVisibility(bool val, int index) {
    _toolbarItemList[index].visible = val;
    saveToolbarLoadout(_toolbarItemList);
    notifyListeners();
  }

  void updateListOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final toolbarItem = _toolbarItemList.removeAt(oldIndex);
    _toolbarItemList.insert(newIndex, toolbarItem);

    saveToolbarLoadout(_toolbarItemList);
    notifyListeners();
  }
}
