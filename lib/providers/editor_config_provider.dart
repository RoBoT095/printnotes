import 'package:flutter/material.dart';

import 'package:printnotes/constants/toolbar_items_list.dart';
import 'package:printnotes/utils/config_file/toolbar_config_handler.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class EditorConfigProvider with ChangeNotifier {
  double _fontSize = 16;
  bool _isEditing = false;
  List<ToolbarConfigItem> _toolbarItemList = [];

  double get fontSize => _fontSize;
  bool get isEditing => _isEditing;
  List<ToolbarConfigItem> get toolbarItemList => _toolbarItemList;

  EditorConfigProvider() {
    loadEditorConfig();
  }

  void loadEditorConfig() async {
    final fontSize = await UserEditorConfig.getFontSize();
    final toolbarConfig = loadToolbarLoadout();

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

  void setToolbarConfig(List<ToolbarConfigItem>? configList) {
    if (configList == null || configList.isEmpty) {
      _toolbarItemList = defaultToolbarList;
    } else if (configList.length > defaultToolbarList.length) {
      for (ToolbarConfigItem item in configList) {
        if (!defaultToolbarList.contains(item)) {
          debugPrint('Removed $item from Toolbar configList');
          configList.remove(item);
        }
      }
    } else if (configList.length < defaultToolbarList.length) {
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
