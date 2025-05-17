import 'package:flutter/material.dart';

Widget sectionTitle(String title, Color color,
    {double? padding, double? fontSize}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: fontSize ?? 20,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
