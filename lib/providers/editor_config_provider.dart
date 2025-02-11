import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class EditorConfigProvider with ChangeNotifier {
  double _fontSize = 16;

  double get fontSize => _fontSize;

  EditorConfigProvider() {
    loadEditorConfig();
  }

  void loadEditorConfig() async {
    final fontSize = await UserEditorConfig.getFontSize();

    setFontSize(fontSize);
  }

  void setFontSize(double fontSize) {
    _fontSize = fontSize;
    UserEditorConfig.setFontSize(fontSize);
    notifyListeners();
  }
}
