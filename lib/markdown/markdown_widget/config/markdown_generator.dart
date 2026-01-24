import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as m;

import '../widget/blocks/leaf/heading.dart';
import '../widget/span_node.dart';
import '../widget/widget_visitor.dart';
import 'configs.dart';
import 'toc.dart';

typedef HeadingNodeFilter = bool Function(HeadingNode toc);

///use [MarkdownGenerator] to transform markdown data to [Widget] list, so you can render it by any type of [ListView]
class MarkdownGenerator {
  final Iterable<m.InlineSyntax> inlineSyntaxList;
  final Iterable<m.BlockSyntax> blockSyntaxList;
  final EdgeInsets linesMargin;
  final List<SpanNodeGeneratorWithTag> generators;
  final SpanNodeAcceptCallback? onNodeAccepted;
  final m.ExtensionSet? extensionSet;
  final TextNodeGenerator? textGenerator;
  final SpanNodeBuilder? spanNodeBuilder;
  final RichTextBuilder? richTextBuilder;
  final RegExp? splitRegExp;
  final HeadingNodeFilter headingNodeFilter;

  /// Use [headingNodeFilter] to filter the levels of headings you want to show.
  /// e.g.
  /// ```dart
  /// (HeadingNode node) => {'h1', 'h2'}.contains(node.headingConfig.tag)
  /// ```
  MarkdownGenerator(
      {this.inlineSyntaxList = const [],
      this.blockSyntaxList = const [],
      this.linesMargin = const EdgeInsets.symmetric(vertical: 8),
      this.generators = const [],
      this.onNodeAccepted,
      this.extensionSet,
      this.textGenerator,
      this.spanNodeBuilder,
      this.richTextBuilder,
      this.splitRegExp,
      headingNodeFilter})
      : headingNodeFilter = headingNodeFilter ?? allowAll;

  ///convert [data] to widgets
  ///[onTocList] can provider [Toc] list
  List<Widget> buildWidgets(String data,
      {ValueCallback<List<Toc>>? onTocList, MarkdownConfig? config}) {
    final mdConfig = config ?? MarkdownConfig.defaultConfig;
    final m.Document document = m.Document(
      extensionSet: extensionSet ?? m.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
      inlineSyntaxes: inlineSyntaxList,
      blockSyntaxes: blockSyntaxList,
    );
    final regExp = splitRegExp ?? WidgetVisitor.defaultSplitRegExp;
    final List<String> lines = data.split(regExp);

    // Preprocess lines to replace task list markers "- [ ]" / "- [x]" with
    // an HTML input element that includes a data-line attribute so we can
    // identify which source line the checkbox originated from.
    final taskRegex = RegExp(r'^(\s*[-\*\+]\s*)\[([ xX])\]\s*(.*)');
    final List<String> processed = List<String>.from(lines);
    // When splitting by `regExp` we get newline tokens as their own entries.
    // Keep a separate plainLine counter so the data-line maps to the
    // visual line number in the original text (split by "\n").
    int plainLine = 0;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      // skip newline tokens from split
      if (line == '\r' || line == '\n' || line == '\r\n') {
        continue;
      }
      final m = taskRegex.firstMatch(line);
      if (m != null) {
        final prefix = m.group(1) ?? '';
        final mark = m.group(2) ?? ' ';
        final rest = m.group(3) ?? '';
        final checkedAttr = (mark.toLowerCase() == 'x') ? ' checked="true"' : '';
        // inject an inline HTML input; keep the list prefix so markdown list parsing remains
        processed[i] = '$prefix<input type="checkbox" data-line="$plainLine"$checkedAttr /> $rest';
      }
      plainLine++;
    }

    final List<m.Node> nodes = document.parseLines(processed);
    final List<Toc> tocList = [];
    final visitor = WidgetVisitor(
        config: mdConfig,
        generators: generators,
        textGenerator: textGenerator,
        richTextBuilder: richTextBuilder,
        splitRegExp: regExp,
        onNodeAccepted: (node, index) {
          onNodeAccepted?.call(node, index);
          if (node is HeadingNode && headingNodeFilter(node)) {
            final listLength = tocList.length;
            tocList.add(
                Toc(node: node, widgetIndex: index, selfIndex: listLength));
          }
        });
    final spans = visitor.visit(nodes);
    onTocList?.call(tocList);
    final List<Widget> widgets = [];
    for (var span in spans) {
      final textSpan = spanNodeBuilder?.call(span) ?? span.build();
      final richText = richTextBuilder?.call(textSpan) ?? Text.rich(textSpan);
      widgets.add(Padding(padding: linesMargin, child: richText));
    }
    return widgets;
  }

  static bool allowAll(HeadingNode toc) => true;
}

typedef SpanNodeBuilder = TextSpan Function(SpanNode spanNode);

typedef RichTextBuilder = Widget Function(InlineSpan span);
