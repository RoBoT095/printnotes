import 'package:flutter/material.dart';
import 'package:printnotes/constants/themes/theme_color_data.dart';
import 'package:printnotes/utils/config_file/custom_themes/theme_json_handler.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _colorScheme = 'default';
  bool _useCustomTheme = false;
  bool _pureBlack = false;

  ThemeMode get themeMode => _themeMode;
  String get themeModeString => _themeModeToString(_themeMode);
  String get colorScheme => _colorScheme;
  bool get useCustomTheme => _useCustomTheme;
  bool get pureBlack => _pureBlack;

  ThemeProvider() {
    loadPreferences();
  }

  String _themeModeToString(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  bool isThemeCustom(String colorScheme) {
    return colorScheme == 'custom' ? true : false;
  }

  void loadPreferences() async {
    final savedTheme = await UserThemingPref.getThemeMode();
    final savedColorScheme = await UserThemingPref.getColorScheme();
    final usePureBlack = await UserThemingPref.getPureBlackBG();

    setThemeMode(savedTheme);
    setColorScheme(savedColorScheme);
    setUseCustomTheme(isThemeCustom(colorScheme));
    setPureBlackBG(usePureBlack);
  }

  void setThemeMode(String theme) {
    _themeMode = _stringToThemeMode(theme);
    UserThemingPref.setThemeMode(theme);
    notifyListeners();
  }

  void setColorScheme(String colorScheme) {
    _colorScheme = colorScheme;
    UserThemingPref.setColorScheme(colorScheme);

    setUseCustomTheme(isThemeCustom(colorScheme));
    notifyListeners();
  }

  void setUseCustomTheme(bool useCustomTheme) {
    _useCustomTheme = useCustomTheme;
    notifyListeners();
  }

  void setPureBlackBG(bool pureBlackBG) {
    _pureBlack = pureBlackBG;
    UserThemingPref.setPureBlackBG(pureBlackBG);
    notifyListeners();
  }

  ColorScheme getThemeData(BuildContext context) {
    final brightness = _themeMode == ThemeMode.system
        ? MediaQuery.platformBrightnessOf(context)
        : _themeMode == ThemeMode.light
            ? Brightness.light
            : Brightness.dark;
    bool isDark = brightness == Brightness.dark;
    Color? pureBlack = isDark && _pureBlack ? Colors.black : null;
    switch (_colorScheme) {
      case 'nordic':
        return !isDark
            ? AppThemes.lightNordic
            : AppThemes.darkNordic.copyWith(surface: pureBlack);
      case 'green_apple':
        return !isDark
            ? AppThemes.lightGreenApple
            : AppThemes.darkGreenApple.copyWith(surface: pureBlack);
      case 'lavender':
        return !isDark
            ? AppThemes.lightLavender
            : AppThemes.darkLavender.copyWith(surface: pureBlack);
      case 'strawberry':
        return !isDark
            ? AppThemes.lightStrawberry
            : AppThemes.darkStrawberry.copyWith(surface: pureBlack);
      // case 'dracula': return !isDark ? AppThemes.lightDracula : AppThemes.darkDracula;
      case 'custom':
        return customThemeBuilder(isDark) ??
            (!isDark
                ? AppThemes.lightDefault
                : AppThemes.darkDefault.copyWith(surface: pureBlack));
      default:
        return brightness == Brightness.light
            ? AppThemes.lightDefault
            : AppThemes.darkDefault.copyWith(surface: pureBlack);
    }
  }
}
