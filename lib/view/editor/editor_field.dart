import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      autofocus: false,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}
