import 'package:flutter/material.dart';

Widget sectionTitle(String title, Color color, {double? padding}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8),
    child: Text(
      title,
      style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
    ),
  );
}
