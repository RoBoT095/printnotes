import 'package:flutter/material.dart';

import 'package:printnotes/utils/config_file/custom_themes/custom_theme_model.dart';
import 'package:printnotes/utils/configs/data_path.dart';

void saveSelectedThemeToConfig(Map<String, dynamic> selectedThemes) {
  final configFileMap = DataPath.loadJsonConfigFile(DataPath.mainConfigFile);

  // Object existence check for "SelectedCustomThemes", create if null
  configFileMap['SelectedCustomThemes'] ??= {};

  // Add the map of selected themes to config
  configFileMap['SelectedCustomThemes'] = selectedThemes;

  DataPath.saveJsonConfigFile(DataPath.mainConfigFile, configFileMap);
}

Map<String, dynamic> loadSelectedThemeFromConfig() {
  final configFileMap = DataPath.loadJsonConfigFile(DataPath.mainConfigFile);
  if (configFileMap['SelectedCustomThemes'] != null) {
    return configFileMap['SelectedCustomThemes'];
  }
  return {"dark": "", "light": ""};
}

void addThemeToConfig(CustomThemeJson themeJson) {
  final configFileMap = DataPath.loadJsonConfigFile(DataPath.mainConfigFile);

  // Array existence check for "UserCustomThemes", create if null
  configFileMap['UserCustomThemes'] ??= [];

  // // Add the new theme object to array
  configFileMap['UserCustomThemes'].add(themeJson.toJson());

  DataPath.saveJsonConfigFile(DataPath.mainConfigFile, configFileMap);
}

// Identifies theme by name and deletes it
void deleteCustomTheme(Map<String, dynamic> themeJson) {
  final configFileMap = DataPath.loadJsonConfigFile(DataPath.mainConfigFile);

  final themes = configFileMap['UserCustomThemes'] as List<dynamic>;
  themes.removeWhere((theme) => theme['name'] == themeJson['name']);

  DataPath.saveJsonConfigFile(DataPath.mainConfigFile, configFileMap);
}

// TODO: Maybe merge into addThemeToConfig
// Adds theme back to list if accidentally deleted, aka theme undo handler
void restoreCustomTheme(Map<String, dynamic> themeJson) {
  final configFileMap = DataPath.loadJsonConfigFile(DataPath.mainConfigFile);

  final themes = configFileMap['UserCustomThemes'] as List<dynamic>;
  themes.add(themeJson);

  DataPath.saveJsonConfigFile(DataPath.mainConfigFile, configFileMap);
}

// Go through config file and return all themes that are either dark or light
List<dynamic> listAllThemeFromConfig({required bool isDark}) {
  final configFileMap = DataPath.loadJsonConfigFile(DataPath.mainConfigFile);
  final themesList = [];
  if (configFileMap['UserCustomThemes'] != null) {
    final themes = configFileMap['UserCustomThemes'] as List<dynamic>;
    for (final theme in themes) {
      if (isDark && theme['brightness'] == 0) {
        themesList.add(theme);
      }
      if (!isDark && theme['brightness'] == 1) {
        themesList.add(theme);
      }
    }
  }
  return themesList;
}

// Take json and build ColorScheme for app to use as theme
ColorScheme? customThemeBuilder(bool isDark) {
  final selectedTheme = loadSelectedThemeFromConfig();
  for (final theme in listAllThemeFromConfig(isDark: isDark)) {
    if (theme['name'] == selectedTheme[isDark ? 'dark' : 'light']) {
      return ColorScheme(
        brightness: Brightness.values.firstWhere(
          (e) => e.index == theme['brightness'],
        ),
        primary: Color(theme['primary']),
        onPrimary: Color(theme['onPrimary']),
        secondary: Color(theme['secondary']),
        onSecondary: Color(theme['onSecondary']),
        surface: Color(theme['surface']),
        onSurface: Color(theme['onSurface']),
        surfaceContainer: Color(theme['surfaceContainer']),
        error: Colors.red,
        onError: Colors.yellow,
      );
    }
  }
  return null;
}
