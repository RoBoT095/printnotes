import 'package:flutter/material.dart';
import '../markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

const _superscriptTag = 'superscript';

class SuperscriptNode extends SpanNode {
  final Map<String, String> attribute;
  final MarkdownConfig config;

  String get superscriptId => attribute['id'] ?? '';

  SuperscriptNode(this.attribute, this.config);

  @override
  InlineSpan build() => TextSpan(
        text: superscriptId,
        style: config.p.textStyle.merge(
            parentStyle?.copyWith(fontFeatures: [FontFeature.superscripts()])),
      );
}

SpanNodeGeneratorWithTag superscriptGeneratorWithTag = SpanNodeGeneratorWithTag(
    tag: _superscriptTag,
    generator: (e, config, visitor) => SuperscriptNode(e.attributes, config));

class SuperscriptSyntax extends m.InlineSyntax {
  SuperscriptSyntax() : super(r'\^(.*?)\^');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(_superscriptTag);
    final input = match.input;
    el.attributes['id'] = input.substring(match.start + 1, match.end - 1);
    parser.addNode(el);
    return true;
  }
}
