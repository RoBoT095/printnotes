import 'dart:convert';

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
