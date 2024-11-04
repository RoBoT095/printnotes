import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

const _highlighterTag = 'highlighter';

class HighlighterNode extends SpanNode {
  final Map<String, String> attribute;
  final MarkdownConfig config;

  String get highlightId => attribute['id'] ?? '';

  HighlighterNode(this.attribute, this.config);

  @override
  InlineSpan build() => TextSpan(
        text: highlightId,
        style: parentStyle?.copyWith(
                backgroundColor: const Color.fromARGB(148, 255, 225, 118)) ??
            config.p.textStyle.copyWith(
                backgroundColor: const Color.fromARGB(148, 255, 225, 118)),
      );
}

SpanNodeGeneratorWithTag highlighterGeneratorWithTag = SpanNodeGeneratorWithTag(
    tag: _highlighterTag,
    generator: (e, config, visitor) => HighlighterNode(e.attributes, config));

class HighlighterSyntax extends m.InlineSyntax {
  HighlighterSyntax() : super(r'==(.*?)==');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(_highlighterTag);
    final input = match.input;
    el.attributes['id'] = input.substring(match.start + 2, match.end - 2);
    parser.addNode(el);
    return true;
  }
}
