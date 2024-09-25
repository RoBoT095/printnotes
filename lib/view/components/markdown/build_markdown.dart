import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';

import 'package:printnotes/view/components/markdown/rendering/code_wrapper.dart';
import 'package:printnotes/view/components/markdown/rendering/custom_node.dart';
import 'package:printnotes/view/components/markdown/rendering/latex.dart';
import 'package:printnotes/view/components/widgets/markdown_checkbox.dart';

Widget buildMarkdownView(BuildContext context,
    {required String data, bool? selectable, bool? previewMode}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final config =
      isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

  codeWrapper(child, text, language) => CodeWrapperWidget(
        child,
        text,
        language,
        previewMode: previewMode,
      );

  return MarkdownBlock(
    data: data,
    selectable: selectable ?? true,
    config: config.copy(configs: [
      CheckBoxConfig(builder: (checked) => markdownCheckBox(checked)),
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
          ? PreConfig.darkConfig
              .copy(theme: a11yDarkTheme, wrapper: codeWrapper)
          : const PreConfig().copy(theme: a11yLightTheme, wrapper: codeWrapper),
    ]),
    generator: MarkdownGenerator(
      generators: [latexGenerator],
      inlineSyntaxList: [LatexSyntax()],
      textGenerator: (node, config, visitor) =>
          CustomTextNode(node.textContent, config, visitor),
      richTextBuilder: (span) => Text.rich(
        span,
        textScaler: const TextScaler.linear(1),
      ),
    ),
  );
}
