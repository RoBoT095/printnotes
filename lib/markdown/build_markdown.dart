import 'package:flutter/material.dart';
import './markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/editor_config_provider.dart';

import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';

import 'package:printnotes/markdown/rendering/code_wrapper.dart';
import 'package:printnotes/markdown/rendering/custom_img_builder.dart';
import 'package:printnotes/markdown/rendering/custom_node.dart';
import 'package:printnotes/markdown/rendering/latex.dart';
import 'package:printnotes/markdown/rendering/wiki_link.dart';
import 'package:printnotes/markdown/rendering/highlighter.dart';
import 'package:printnotes/markdown/rendering/underline.dart';
import 'package:printnotes/markdown/rendering/note_tags.dart';

import 'package:printnotes/markdown/link_handler.dart';

MarkdownConfig theMarkdownConfigs(
  BuildContext context, {
  required String filePath,
  bool? hideCodeButtons,
  bool inEditor = false,
  Color? textColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final config =
      isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

  final userCodeHighlight = context.watch<ThemeProvider>().codeHighlight;

  codeWrapper(child, text, language) => CodeWrapperWidget(child, text, language,
      hideCodeButtons: hideCodeButtons);

  double editorFontSize = context.watch<EditorConfigProvider>().fontSize;

  return config.copy(configs: [
    PConfig(
      textStyle: TextStyle(
        fontSize: inEditor ? editorFontSize : 16,
        color: textColor,
      ),
    ),
    H1Config(
      style: TextStyle(
        fontSize: inEditor ? editorFontSize + 16 : 32,
        color: textColor,
      ),
    ),
    H2Config(
      style: TextStyle(
        fontSize: inEditor ? editorFontSize + 8 : 24,
        color: textColor,
      ),
    ),
    H3Config(
      style: TextStyle(
        fontSize: inEditor ? editorFontSize + 4 : 20,
        color: textColor,
      ),
    ),
    H4Config(
      style: TextStyle(
        fontSize: inEditor ? editorFontSize : 16,
        color: textColor,
      ),
    ),
    H5Config(
      style: TextStyle(
        fontSize: inEditor ? editorFontSize : 16,
        color: textColor,
      ),
    ),
    H6Config(
      style: TextStyle(
        fontSize: inEditor ? editorFontSize : 16,
        color: textColor,
      ),
    ),
    ListConfig(marginLeft: editorFontSize * 1.5),
    CheckBoxConfig(size: inEditor ? editorFontSize * 1.25 : null),
    TableConfig(
      wrapper: (table) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: table,
      ),
    ),
    HrConfig(
      height: 2,
      color:
          textColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
    ),
    BlockquoteConfig(
      textColor:
          textColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      sideColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
    ),
    ImgConfig(
      builder: (url, attributes) => CustomImgBuilder(url, filePath, attributes),
    ),
    LinkConfig(onTap: (url) => linkHandler(context, url)),
    WikiLinkConfig(onTap: (url) => linkHandler(context, url)),
    const PreConfig().copy(
      theme: themeMap[userCodeHighlight] ??
          (isDark ? a11yDarkTheme : a11yLightTheme),
      decoration: BoxDecoration(
          color: inEditor
              ? Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5)
              : Theme.of(context).colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2))),
      wrapper: codeWrapper,
      textStyle: TextStyle(fontSize: inEditor ? editorFontSize : null),
      styleNotMatched: TextStyle(fontSize: inEditor ? editorFontSize : null),
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
      // wikiLinkGeneratorWithTag,
      highlighterGeneratorWithTag,
      underlineGeneratorWithTag,
      noteTagGenerator,
    ],
    inlineSyntaxList: [
      if (context.watch<SettingsProvider>().useLatex) LatexSyntax(),
      WikiLinkSyntax(),
      HighlighterSyntax(),
      UnderlineSyntax(),
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

Widget buildMarkdownWidget(
  BuildContext context, {
  required String data,
  required String filePath,
  bool? selectable,
  TocController? tocController,
}) {
  return MarkdownWidget(
    data: data,
    selectable: selectable ?? true,
    config: theMarkdownConfigs(context, filePath: filePath, inEditor: true),
    tocController: tocController,
    markdownGenerator: theMarkdownGenerators(context),
  );
}
