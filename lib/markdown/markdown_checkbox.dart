import 'package:flutter/material.dart';

Widget markdownCheckBox(bool checked, double? size) {
  return SizedBox(
    width: size ?? 20,
    height: size ?? 20,
    child: Checkbox(
      value: checked,
      hoverColor: null,
      focusColor: null,
      splashRadius: 0,
      onChanged: (value) {},
    ),
  );
}
