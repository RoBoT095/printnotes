import 'package:flutter/material.dart';
import 'package:printnotes/constants/themes/theme_color_data.dart';
import 'package:printnotes/utils/config_file/custom_themes/theme_json_handler.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

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

  ColorScheme getThemeData(BuildContext context) {
    final brightness = _themeMode == ThemeMode.system
        ? MediaQuery.platformBrightnessOf(context)
        : _themeMode == ThemeMode.light
            ? Brightness.light
            : Brightness.dark;
    bool isDark = brightness == Brightness.dark;
    switch (_colorScheme) {
      case 'nordic':
        return !isDark ? AppThemes.lightNordic : AppThemes.darkNordic;
      case 'green_apple':
        return !isDark ? AppThemes.lightGreenApple : AppThemes.darkGreenApple;
      case 'lavender':
        return !isDark ? AppThemes.lightLavender : AppThemes.darkLavender;
      case 'strawberry':
        return !isDark ? AppThemes.lightStrawberry : AppThemes.darkStrawberry;
      // case 'dracula': return !isDark ? AppThemes.lightDracula : AppThemes.darkDracula;
      case 'custom':
        return customThemeBuilder(isDark) ??
            (!isDark ? AppThemes.lightDefault : AppThemes.darkDefault);
      default:
        return brightness == Brightness.light
            ? AppThemes.lightDefault
            : AppThemes.darkDefault;
    }
  }
}
