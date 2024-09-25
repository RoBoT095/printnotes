import 'package:flutter/material.dart';

SnackBar customSnackBar(String text, {double? width, int? durationMil}) {
  return SnackBar(
    width: width ?? const SnackBarThemeData().width,
    behavior: SnackBarBehavior.floating,
    // backgroundColor: Theme.of(context).colorScheme.onSurface,
    duration: Duration(milliseconds: durationMil ?? 800),
    content: Text(
      text,
      textAlign: TextAlign.center,
      // style: TextStyle(
      //   color: Theme.of(context).colorScheme.surface,
      // ),
    ),
  );
}
