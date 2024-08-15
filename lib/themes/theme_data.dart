import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightDefault = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(77, 143, 255, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(68, 138, 255, 1),
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      surfaceContainer: Color.fromRGBO(246, 250, 255, 1),
    ),
  );

  static final ThemeData darkDefault = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(0, 67, 179, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(68, 138, 255, 1),
      onSecondary: Colors.black,
      surface: Color.fromRGBO(33, 33, 33, 1),
      onSurface: Colors.white,
      surfaceContainer: Color.fromRGBO(41, 43, 44, 1),
    ),
  );

  static final ThemeData lightGreenApple = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(90, 191, 95, 1),
      onPrimary: Colors.black,
      secondary: Color.fromRGBO(127, 205, 131, 1),
      onSecondary: Colors.black,
      surface: Color.fromRGBO(237, 248, 237, 1),
      onSurface: Colors.black,
      surfaceContainer: Color.fromRGBO(227, 241, 227, 1),
    ),
  );

  static final ThemeData darkGreenApple = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(50, 128, 54, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(137, 195, 85, 1),
      onSecondary: Colors.white,
      surface: Color.fromRGBO(26, 47, 26, 1),
      onSurface: Colors.white,
      surfaceContainer: Color.fromRGBO(32, 61, 32, 1),
    ),
  );

  static final ThemeData lightLavender = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(106, 106, 225, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(134, 134, 219, 1),
      onSecondary: Colors.white,
      surface: Color.fromRGBO(224, 224, 253, 1),
      onSurface: Colors.black,
      surfaceContainer: Color.fromRGBO(214, 214, 252, 1),
    ),
  );

  static final ThemeData darkLavender = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(98, 38, 140, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(151, 74, 206, 1),
      onSecondary: Colors.white,
      surface: Color.fromRGBO(42, 16, 60, 1),
      onSurface: Color.fromRGBO(222, 232, 255, 1),
      surfaceContainer: Color.fromRGBO(54, 23, 77, 1),
    ),
  );

  static final ThemeData lightStrawberry = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(201, 82, 80, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(213, 120, 119, 1),
      onSecondary: Colors.black,
      surface: Color.fromRGBO(249, 236, 236, 1),
      onSurface: Colors.black,
      surfaceContainer: Color.fromRGBO(247, 228, 228, 1),
    ),
  );

  static final ThemeData darkStrawberry = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        primary: Color.fromRGBO(136, 44, 42, 1),
        onPrimary: Colors.white,
        secondary: Color.fromRGBO(182, 65, 63, 1),
        onSecondary: Colors.white,
        surface: Color.fromRGBO(58, 19, 18, 1),
        onSurface: Colors.white,
        surfaceContainer: Color.fromRGBO(75, 27, 26, 1)),
  );
}
