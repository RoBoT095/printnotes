import 'package:flutter/material.dart';
import 'package:printnotes/themes/theme_data.dart';
import 'package:printnotes/utils/configs/user_theming.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _colorScheme = 'default';

  ThemeMode get themeMode => _themeMode;
  String get colorScheme => _colorScheme;

  ThemeProvider() {
    loadPreferences();
  }

  void loadPreferences() async {
    final savedTheme = await UserThemingPref.getThemeMode();
    final savedColorScheme = await UserThemingPref.getColorScheme();

    setThemeMode(savedTheme);
    setColorScheme(savedColorScheme);
  }

  void setThemeMode(String theme) {
    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    UserThemingPref.setThemeMode(theme);
    notifyListeners();
  }

  void setColorScheme(String colorScheme) {
    _colorScheme = colorScheme;
    UserThemingPref.setColorScheme(colorScheme);
    notifyListeners();
  }

  ThemeData getThemeData(BuildContext context) {
    final brightness = _themeMode == ThemeMode.system
        ? MediaQuery.of(context).platformBrightness
        : _themeMode == ThemeMode.light
            ? Brightness.light
            : Brightness.dark;
    switch (_colorScheme) {
      case 'green_apple':
        return brightness == Brightness.light
            ? AppThemes.lightGreenApple
            : AppThemes.darkGreenApple;
      case 'lavender':
        return brightness == Brightness.light
            ? AppThemes.lightLavender
            : AppThemes.darkLavender;
      case 'strawberry':
        return brightness == Brightness.light
            ? AppThemes.lightStrawberry
            : AppThemes.darkStrawberry;
      default:
        return brightness == Brightness.light
            ? AppThemes.lightDefault
            : AppThemes.darkDefault;
    }
  }
}
