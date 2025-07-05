import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:printnotes/markdown/markdown_widget/markdown_widget.dart';

///Tag: [MarkdownTag.wl]

class WikiLinkNode extends ElementNode {
  final Map<String, String> attribute;
  final WikiLinkConfig wikiLinkConfig;

  String get wikiLinkId => attribute['id'] ?? '';

  WikiLinkNode(this.attribute, this.wikiLinkConfig);

  @override
  InlineSpan build() {
    String parseCustomName(String text) {
      int pipeIndex = text.lastIndexOf('|');
      // If pipeIndex is -1, it means '|' was not found.
      // If pipeIndex is less than text.length - 1, it means '|' is the last character,
      if (pipeIndex != -1 && pipeIndex < text.length - 1) {
        String pipedText = text.substring(pipeIndex + 1).trim();
        if (pipedText.isNotEmpty) return pipedText;
      }
      return text;
    }

    String parseLink(String text) {
      // TODO: Add support for linking to headers and displaying them as:
      // [[note#topic]] to 'note > topic'
      int pipeIndex = text.lastIndexOf('|');
      // If pipeIndex is -1, it means '|' was not found.
      if (pipeIndex != -1) {
        return text.substring(0, pipeIndex).trim();
      }
      return text;
    }

    String wikiLinkText = parseCustomName(wikiLinkId);

    return TextSpan(
        text: wikiLinkText,
        style: parentStyle?.merge(wikiLinkConfig.style) ?? wikiLinkConfig.style,
        recognizer: TapGestureRecognizer()
          ..onTap = () => _onLinkTap(parseLink(wikiLinkId)));
  }

  void _onLinkTap(String url) {
    if (wikiLinkConfig.onTap != null) {
      wikiLinkConfig.onTap?.call(url);
    }
  }

  @override
  TextStyle get style =>
      parentStyle?.merge(wikiLinkConfig.style) ?? wikiLinkConfig.style;
}

class WikiLinkConfig implements LeafConfig {
  final TextStyle style;
  final ValueCallback<String>? onTap;

  const WikiLinkConfig(
      {this.style = const TextStyle(
          color: Color(0xff0969da), decoration: TextDecoration.underline),
      this.onTap});

  @nonVirtual
  @override
  String get tag => MarkdownTag.wl.name;
}

class WikiLinkSyntax extends m.InlineSyntax {
  WikiLinkSyntax() : super(r'\[\[(.*?)\]\]');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    m.Element el = m.Element.withTag(MarkdownTag.wl.name);
    final input = match.input;
    el.attributes['id'] = input.substring(match.start + 2, match.end - 2);
    parser.addNode(el);
    return true;
  }
}
