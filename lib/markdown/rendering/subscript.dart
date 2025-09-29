import 'package:flutter/material.dart';
import '../markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

const _subscriptTag = 'subscript';

class SubscriptNode extends SpanNode {
  final Map<String, String> attribute;
  final MarkdownConfig config;

  String get subscriptId => attribute['id'] ?? '';

  SubscriptNode(this.attribute, this.config);

  @override
  InlineSpan build() => TextSpan(
        text: subscriptId,
        style: config.p.textStyle.merge(
            parentStyle?.copyWith(fontFeatures: [FontFeature.subscripts()])),
      );
}

SpanNodeGeneratorWithTag subscriptGeneratorWithTag = SpanNodeGeneratorWithTag(
    tag: _subscriptTag,
    generator: (e, config, visitor) => SubscriptNode(e.attributes, config));

class SubscriptSyntax extends m.InlineSyntax {
  SubscriptSyntax() : super(r'~(.*?)~');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(_subscriptTag);
    final input = match.input;
    el.attributes['id'] = input.substring(match.start + 1, match.end - 1);
    parser.addNode(el);
    return true;
  }
}
