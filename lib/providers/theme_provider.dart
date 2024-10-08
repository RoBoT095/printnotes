import 'package:flutter/material.dart';
import 'package:printnotes/constants/themes/theme_color_data.dart';
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

  // From theme maker as reference

  // void updateBrightness(Brightness brightness) {
  //   _colorScheme = _colorScheme.copyWith(brightness: brightness);
  //   notifyListeners();
  // }

  // void updateColor(String property, Color color) {
  //   _colorScheme = _colorScheme.copyWith(
  //     primary: property == 'primary' ? color : _colorScheme.primary,
  //     onPrimary: property == 'onPrimary' ? color : _colorScheme.onPrimary,
  //     secondary: property == 'secondary' ? color : _colorScheme.secondary,
  //     onSecondary:
  //         property == 'onSecondary' ? color : _customColorScheme.onSecondary,
  //     surface: property == 'surface' ? color : _customColorScheme.surface,
  //     onSurface: property == 'onSurface' ? color : _colorScheme.onSurface,
  //     surfaceContainer: property == 'surfaceContainer'
  //         ? color
  //         : _colorScheme.surfaceContainer,
  //   );
  //   notifyListeners();
  // }
}
