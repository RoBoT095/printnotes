import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.controller,
    this.scrollController,
    required this.onChanged,
    this.undoController,
    this.fontSize = 16,
  });

  final TextEditingController controller;
  final ScrollController? scrollController;
  final Function(String) onChanged;
  final UndoHistoryController? undoController;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      scrollController: scrollController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      enableSuggestions: true,
      autocorrect: true,
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
