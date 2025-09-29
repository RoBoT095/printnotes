import 'package:flutter/material.dart';
import '../markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

const _strikethroughTag = 'strikethrough';

class StrikethroughNode extends SpanNode {
  final Map<String, String> attribute;
  final MarkdownConfig config;

  String get strikethroughId => attribute['id'] ?? '';

  StrikethroughNode(this.attribute, this.config);

  @override
  InlineSpan build() => TextSpan(
        text: strikethroughId,
        style: config.p.textStyle.merge(
            parentStyle?.copyWith(decoration: TextDecoration.lineThrough)),
      );
}

SpanNodeGeneratorWithTag strikethroughGeneratorWithTag =
    SpanNodeGeneratorWithTag(
        tag: _strikethroughTag,
        generator: (e, config, visitor) =>
            StrikethroughNode(e.attributes, config));

class StrikethroughSyntax extends m.InlineSyntax {
  StrikethroughSyntax() : super(r'~~(.*?)~~');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(_strikethroughTag);
    final input = match.input;
    el.attributes['id'] = input.substring(match.start + 2, match.end - 2);
    parser.addNode(el);
    return true;
  }
}
