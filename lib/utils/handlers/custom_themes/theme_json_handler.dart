import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/configs/data_path.dart';

class CustomThemeJson {
  String name;
  int brightness;
  int primary;
  int onPrimary;
  int secondary;
  int onSecondary;
  int surface;
  int onSurface;
  int surfaceContainer;

  CustomThemeJson({
    required this.name,
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
  });

  factory CustomThemeJson.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return CustomThemeJson(
      name: json['name'],
      brightness: json['brightness'],
      primary: json['primary'],
      onPrimary: json['onPrimary'],
      secondary: json['secondary'],
      onSecondary: json['onSecondary'],
      surface: json['surface'],
      onSurface: json['onSurface'],
      surfaceContainer: json['surfaceContainer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "brightness": brightness,
      "primary": primary,
      "onPrimary": onPrimary,
      "secondary": secondary,
      "onSecondary": onSecondary,
      "surface": surface,
      "onSurface": onSurface,
      "surfaceContainer": surfaceContainer,
    };
  }
}

void addThemeToConfig(CustomThemeJson themeJson) {
  final configFileMap = DataPath.loadJsonConfigFile();

  // Array existence check for "UserCustomThemes", create if not
  configFileMap['UserCustomThemes'] ??= [];

  // // Add the new theme object to array
  configFileMap['UserCustomThemes'].add(themeJson.toJson());

  DataPath.saveJsonConfigFile(configFileMap);
}

void deleteCustomTheme(Map<String, dynamic> themeJson) {
  final configFileMap = DataPath.loadJsonConfigFile();

  final themes = configFileMap['UserCustomThemes'] as List<dynamic>;
  themes.removeWhere((theme) => theme['name'] == themeJson['name']);

  DataPath.saveJsonConfigFile(configFileMap);
}

// Go through config file and return all dark themes
List<dynamic> listDarkThemeFromConfig() {
  final configFileMap = DataPath.loadJsonConfigFile();
  final darkThemesList = [];
  if (configFileMap['UserCustomThemes'] != null) {
    final themes = configFileMap['UserCustomThemes'] as List<dynamic>;
    for (final theme in themes) {
      if (theme['brightness'] == 0) {
        darkThemesList.add(theme);
      }
    }
  }
  return darkThemesList;
}

// Go through config file and return all light themes
List<dynamic> listLightThemeFromConfig() {
  final configFileMap = DataPath.loadJsonConfigFile();
  final lightThemesList = [];
  if (configFileMap['UserCustomThemes'] != null) {
    final themes = configFileMap['UserCustomThemes'] as List<dynamic>;
    for (final theme in themes) {
      if (theme['brightness'] == 1) {
        lightThemesList.add(theme);
      }
    }
  }
  return lightThemesList;
}

// Take json and build ColorScheme for app to use as theme
ColorScheme customThemeBuilder(String jsonString) {
  Map<String, dynamic> json = jsonDecode(jsonString);
  return ColorScheme(
    brightness: Brightness.values.firstWhere(
      (e) => e.index == json['brightness'],
    ),
    primary: Color(json['primary']),
    onPrimary: Color(json['onPrimary']),
    secondary: Color(json['secondary']),
    onSecondary: Color(json['onSecondary']),
    surface: Color(json['surface']),
    onSurface: Color(json['onSurface']),
    surfaceContainer: Color(json['surfaceContainer']),
    error: Colors.red,
    onError: Colors.yellow,
  );
}
