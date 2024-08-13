import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MainMarkDownStyles {
  static MarkdownStyleSheet mainMDStyles(BuildContext context) =>
      MarkdownStyleSheet(
        p: const TextStyle(fontSize: 16),
        horizontalRuleDecoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 2)),
        ),
        blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withAlpha(255),
          border: Border(
            left: BorderSide(color: Colors.grey.shade600, width: 3),
          ),
        ),
        listBullet: const TextStyle(fontWeight: FontWeight.bold),
        codeblockDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        code: TextStyle(
            backgroundColor: Colors.transparent,
            color: Theme.of(context).colorScheme.onBackground),
        checkbox: const TextStyle(fontSize: 20),
      );
}
