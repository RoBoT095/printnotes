import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

const _underlineTag = 'underline';

class UnderlineNode extends SpanNode {
  final Map<String, String> attribute;
  final MarkdownConfig config;

  String get underlineId => attribute['id'] ?? '';

  UnderlineNode(this.attribute, this.config);

  @override
  InlineSpan build() => TextSpan(
        text: underlineId,
        style: config.p.textStyle
            .merge(parentStyle?.copyWith(decoration: TextDecoration.underline)),
      );
}

SpanNodeGeneratorWithTag underlineGeneratorWithTag = SpanNodeGeneratorWithTag(
    tag: _underlineTag,
    generator: (e, config, visitor) => UnderlineNode(e.attributes, config));

class UnderlineSyntax extends m.InlineSyntax {
  UnderlineSyntax() : super(r'__(.*?)__');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(_underlineTag);
    final input = match.input;
    el.attributes['id'] = input.substring(match.start + 2, match.end - 2);
    parser.addNode(el);
    return true;
  }
}
