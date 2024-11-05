import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

const _noteTag = 'noteTag';

class NoteTagNode extends SpanNode {
  final Map<String, String> attribute;
  final MarkdownConfig config;
  final Color? tagBackgroundColor;
  final Color? tagTextColor;

  String get noteTagId => attribute['id'] ?? '';

  NoteTagNode(this.attribute, this.config,
      {this.tagBackgroundColor, this.tagTextColor});

  @override
  InlineSpan build() {
    Color defaultBackgroundColor = const Color.fromRGBO(77, 142, 255, 0.298);
    Color defaultTextColor = const Color.fromRGBO(13, 71, 161, 1);
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: tagBackgroundColor ?? defaultBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Text(
                noteTagId,
                style: parentStyle?.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.2
                        ..color = tagTextColor ?? defaultTextColor,
                    ) ??
                    config.p.textStyle.copyWith(
                      color: tagTextColor ?? defaultTextColor,
                      decoration: TextDecoration.underline,
                      decorationColor: tagTextColor ?? defaultTextColor,
                    ),
              ),
              Text(
                noteTagId,
                style: parentStyle?.copyWith(
                      color: tagTextColor ?? defaultTextColor,
                      decoration: TextDecoration.underline,
                      decorationColor: tagTextColor ?? defaultTextColor,
                    ) ??
                    config.p.textStyle.copyWith(
                      // color: tagTextColor ?? defaultTextColor,
                      decoration: TextDecoration.underline,
                      decorationColor: tagTextColor ?? defaultTextColor,
                    ),
              ),
            ],
          )),
    );
  }
}

class NoteTagSyntax extends m.InlineSyntax {
  NoteTagSyntax() : super(r'#\w+');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(_noteTag);
    final input = match.input.substring(match.start, match.end);
    el.attributes['id'] = input;
    parser.addNode(el);
    return true;
  }
}
