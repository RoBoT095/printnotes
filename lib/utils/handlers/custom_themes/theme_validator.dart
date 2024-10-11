import 'dart:convert';

import 'package:flutter/material.dart';

bool validateCustomThemeJson(String jsonString) {
  try {
    // Parse string into json
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // Required keys/colors and their expected value type (all should be int)
    final requiredKeys = [
      'brightness',
      'primary',
      'onPrimary',
      'secondary',
      'onSecondary',
      'surface',
      'onSurface',
      'surfaceContainer'
    ];

    // Check if all required colors exist and are integers
    for (final key in requiredKeys) {
      if (!jsonMap.containsKey(key)) {
        debugPrint('Missing required key: $key');
        return false;
      }

      if (jsonMap[key] is! int) {
        debugPrint('Value for key $key is not an integer');
        return false;
      }
      // Check if brightness is either 0 (dark) or 1 (light)
      if (key == 'brightness' && jsonMap[key] != 0 && jsonMap[key] != 1) {
        debugPrint('Brightness invalid value');
        return false;
      }

      // Check if color value is within 64-bits
      if (!key.contains('brightness') && jsonMap[key] > 9223372036854775807 ||
          jsonMap[key] < -9223372036854775808) {
        debugPrint('Color integer exceeds 64-bits');
        return false;
      }
    }

    // Check if there are any extra keys
    if (jsonMap.length != requiredKeys.length) {
      final extraKeys =
          jsonMap.keys.where((key) => !requiredKeys.contains(key));
      debugPrint('Extra unexpected keys found: $extraKeys');
      return false;
    }

    return true;
  } catch (e) {
    debugPrint('Error parsing JSON: $e');
    return false;
  }
}
