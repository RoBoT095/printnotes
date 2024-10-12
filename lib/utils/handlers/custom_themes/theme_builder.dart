import 'dart:convert';

import 'package:flutter/material.dart';

// Take json and build ColorScheme from it
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
