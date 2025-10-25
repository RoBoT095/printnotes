import 'package:flutter/material.dart';

class AppThemes {
  static const ColorScheme lightDefault = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(77, 143, 255, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(68, 138, 255, 1),
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceContainer: Color.fromRGBO(246, 250, 255, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme darkDefault = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromRGBO(0, 67, 179, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(68, 138, 255, 1),
    onSecondary: Colors.white,
    surface: Color.fromRGBO(33, 33, 33, 1),
    onSurface: Colors.white,
    surfaceContainer: Color.fromRGBO(41, 43, 44, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme lightNordic = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(126, 177, 192, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(136, 192, 208, 1),
    onSecondary: Colors.white,
    surface: Color.fromRGBO(236, 239, 244, 1),
    onSurface: Colors.black,
    surfaceContainer: Color.fromRGBO(229, 233, 240, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme darkNordic = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromRGBO(76, 107, 141, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(135, 192, 208, 1),
    onSecondary: Colors.black,
    surface: Color.fromRGBO(45, 51, 63, 1),
    onSurface: Colors.white,
    surfaceContainer: Color.fromRGBO(66, 74, 94, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme lightGreenApple = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(90, 191, 95, 1),
    onPrimary: Colors.black,
    secondary: Color.fromRGBO(127, 205, 131, 1),
    onSecondary: Colors.black,
    surface: Color.fromRGBO(233, 240, 233, 1),
    onSurface: Colors.black,
    surfaceContainer: Color.fromRGBO(233, 245, 233, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme darkGreenApple = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromRGBO(38, 95, 41, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(134, 199, 77, 1),
    onSecondary: Colors.white,
    surface: Color.fromRGBO(29, 34, 29, 1),
    onSurface: Colors.white,
    surfaceContainer: Color.fromRGBO(30, 51, 30, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme lightLavender = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(106, 106, 225, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(134, 134, 219, 1),
    onSecondary: Colors.white,
    surface: Color.fromRGBO(231, 231, 236, 1),
    onSurface: Colors.black,
    surfaceContainer: Color.fromRGBO(221, 221, 238, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme darkLavender = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromRGBO(98, 38, 140, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(151, 74, 206, 1),
    onSecondary: Colors.white,
    surface: Color.fromRGBO(31, 18, 41, 1),
    onSurface: Color.fromRGBO(222, 232, 255, 1),
    surfaceContainer: Color.fromRGBO(47, 19, 68, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme lightStrawberry = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(201, 82, 80, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(213, 120, 119, 1),
    onSecondary: Colors.black,
    surface: Color.fromRGBO(247, 238, 238, 1),
    onSurface: Colors.black,
    surfaceContainer: Color.fromRGBO(248, 231, 231, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  static const ColorScheme darkStrawberry = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromRGBO(136, 44, 42, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(182, 65, 63, 1),
    onSecondary: Colors.white,
    surface: Color.fromRGBO(48, 10, 8, 1),
    onSurface: Colors.white,
    surfaceContainer: Color.fromRGBO(77, 25, 25, 1),
    error: Colors.red,
    onError: Colors.yellow,
  );

  // Work in Progress
  // ====================
  // static const ColorScheme lightDracula = ColorScheme(
  //   brightness: Brightness.light,
  //   primary: Color.fromRGBO(158, 93, 188, 1),
  //   onPrimary: Colors.white,
  //   secondary: Color.fromRGBO(238, 130, 191, 1),
  //   onSecondary: Colors.white,
  //   surface: Color.fromRGBO(240, 237, 241, 1),
  //   onSurface: Colors.black,
  //   surfaceContainer: Color.fromRGBO(243, 237, 245, 1),
  //   error: Colors.red,
  //   onError: Color.fromRGBO(241, 250, 140, 1),
  // );

  // static const ColorScheme darkDracula = ColorScheme(
  //   brightness: Brightness.dark,
  //   primary: Color.fromRGBO(55, 58, 88, 1),
  //   onPrimary: Colors.white,
  //   secondary: Color.fromRGBO(189, 145, 249, 1),
  //   onSecondary: Colors.black,
  //   surface: Color.fromRGBO(40, 42, 53, 1),
  //   onSurface: Colors.white,
  //   surfaceContainer: Color.fromRGBO(68, 71, 90, 1),
  //   error: Colors.red,
  //   onError: Color.fromRGBO(241, 250, 140, 1),
  // );
}
