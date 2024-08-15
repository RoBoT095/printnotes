import 'package:flutter/material.dart';

Widget markdownCheckBox(bool checked) {
  return SizedBox(
    width: 20,
    height: 20,
    child: Checkbox(
      value: checked,
      hoverColor: null,
      focusColor: null,
      splashRadius: 0,
      onChanged: (value) {},
    ),
  );
}
