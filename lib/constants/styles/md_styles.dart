import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MainMarkDownStyles {
  static MarkdownStyleSheet mainMDStyles(BuildContext context) =>
      MarkdownStyleSheet(
        p: const TextStyle(fontSize: 16),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onSurface)),
        ),
        blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          border: Border(
            left: BorderSide(color: Colors.grey.shade600, width: 3),
          ),
        ),
        listBullet: const TextStyle(fontWeight: FontWeight.bold),
        codeblockDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
        ),
        code: TextStyle(
            backgroundColor: Colors.transparent,
            color: Theme.of(context).colorScheme.onSurface),
        checkbox: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
}
