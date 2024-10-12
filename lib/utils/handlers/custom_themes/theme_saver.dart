import 'dart:convert';

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

void addThemeToConfig(CustomThemeJson themeJson) async {
  final configFileMap = DataPath.loadJsonConfigFile();

  // Array existence check for "UserCustomThemes", create if not
  configFileMap['UserCustomThemes'] ??= [];

  // // Add the new theme object to array
  configFileMap['UserCustomThemes'].add(themeJson.toJson());

  DataPath.saveJsonConfigFile(configFileMap);
}
