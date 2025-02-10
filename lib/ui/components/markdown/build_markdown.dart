import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/editor_config_provider.dart';

import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';

import 'package:printnotes/ui/components/markdown/rendering/code_wrapper.dart';
import 'package:printnotes/ui/components/markdown/rendering/custom_node.dart';
import 'package:printnotes/ui/components/markdown/rendering/highlighter.dart';
import 'package:printnotes/ui/components/markdown/rendering/latex.dart';
import 'package:printnotes/ui/components/markdown/markdown_checkbox.dart';
import 'package:printnotes/ui/components/markdown/rendering/note_tags.dart';

MarkdownConfig theMarkdownConfigs(BuildContext context,
    {bool? hideCodeButtons, bool inEditor = false}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final config =
      isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

  codeWrapper(child, text, language) => CodeWrapperWidget(
        child,
        text,
        language,
        hideCodeButtons: hideCodeButtons,
      );

  double editorFontSize = context.watch<EditorConfigProvider>().fontSize;

  List<WidgetConfig> editorSpecificConfigs = [
    PConfig(textStyle: TextStyle(fontSize: editorFontSize)),
    H1Config(style: TextStyle(fontSize: editorFontSize + 16)),
    H2Config(style: TextStyle(fontSize: editorFontSize + 8)),
    H3Config(style: TextStyle(fontSize: editorFontSize + 4)),
    H4Config(style: TextStyle(fontSize: editorFontSize)),
    H5Config(style: TextStyle(fontSize: editorFontSize)),
    H6Config(style: TextStyle(fontSize: editorFontSize)),
  ];

  return config.copy(configs: [
    if (inEditor) ...editorSpecificConfigs,
    ListConfig(marginLeft: editorFontSize * 1.5),
    CheckBoxConfig(
        builder: (checked) =>
            markdownCheckBox(checked, inEditor ? editorFontSize * 1.25 : null)),
    TableConfig(
        wrapper: (table) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: table,
            )),
    HrConfig(
      height: 2,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
    ),
    BlockquoteConfig(
      textColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      sideColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
    ),
    isDark
        ? PreConfig.darkConfig.copy(theme: a11yDarkTheme, wrapper: codeWrapper)
        : const PreConfig().copy(
            theme: a11yLightTheme,
            wrapper: codeWrapper,
            textStyle: TextStyle(fontSize: inEditor ? editorFontSize : null),
            styleNotMatched:
                TextStyle(fontSize: inEditor ? editorFontSize : null),
          ),
  ]);
}

MarkdownGenerator theMarkdownGenerators(BuildContext context,
    {double? textScale}) {
  // Not an elegant way to customize, but it works
  final isDark = Theme.of(context).brightness == Brightness.dark;
  SpanNodeGeneratorWithTag noteTagGenerator = SpanNodeGeneratorWithTag(
      tag: 'noteTag',
      generator: (e, config, visitor) => NoteTagNode(
            e.attributes,
            config,
            tagBackgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
            tagTextColor: isDark
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
          ));

  return MarkdownGenerator(
    generators: [
      if (context.watch<SettingsProvider>().useLatex) latexGenerator,
      highlighterGeneratorWithTag,
      noteTagGenerator,
    ],
    inlineSyntaxList: [
      if (context.watch<SettingsProvider>().useLatex) LatexSyntax(),
      HighlighterSyntax(),
      NoteTagSyntax()
    ],
    textGenerator: (node, config, visitor) =>
        CustomTextNode(node.textContent, config, visitor),
    richTextBuilder: (span) => Text.rich(
      span,
      textScaler: TextScaler.linear(textScale ?? 1),
    ),
  );
}

Widget buildMarkdownWidget(BuildContext context,
    {required String data, bool? selectable, TocController? tocController}) {
  return MarkdownWidget(
    data: data,
    selectable: selectable ?? true,
    config: theMarkdownConfigs(context, inEditor: true),
    tocController: tocController,
    markdownGenerator: theMarkdownGenerators(context),
  );
}
