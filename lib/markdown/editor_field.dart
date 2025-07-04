import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.undoController,
    this.fontSize = 16,
  });

  final TextEditingController controller;
  final Function(String) onChanged;
  final UndoHistoryController? undoController;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      autofocus: false,
      onChanged: onChanged,
      undoController: undoController,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Theme.of(context).hintColor)),
    );
  }
}
