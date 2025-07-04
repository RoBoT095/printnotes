import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:flutter_highlight/theme_map.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/markdown/build_markdown.dart';

class CodeblockThemePage extends StatelessWidget {
  const CodeblockThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> codeHighlightThemes =
        themeMap.keys.map((key) {
      return DropdownMenuItem(value: key, child: Text(key));
    }).toList();
    String markdownData =
        '```Python\n@requires_authorization\ndef somefunc(param1=\'\', param2=0):\n    r\'\'\'A docstring\'\'\'\n    if param1 > param2: # interesting\n        print \'Gre\\\'ater\'\n    return (param2 - param1 + 1 + 0b10l) or None\n\nclass SomeClass:\n    pass\n\n>>> message = \'\'\'interpreter\n... prompt\'\'\'\n```';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Select Code Theme'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Switch Theme Mode:'),
            trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  context
                      .read<ThemeProvider>()
                      .setThemeMode(value ? 'dark' : 'light');
                }),
          ),
          ListTile(
            title: Text('Code Themes:'),
            trailing: DropdownButton(
              value: context.watch<ThemeProvider>().codeHighlight,
              items: [
                DropdownMenuItem(value: '', child: Text('Auto - Default')),
                ...codeHighlightThemes
              ],
              onChanged: (value) {
                context.read<ThemeProvider>().setCodeHighlight(value ?? '');
              },
            ),
          ),
          if (context.watch<ThemeProvider>().codeHighlight == '')
            Text('Auto switches between a11y-dark and a11y-light'),
          MarkdownBlock(
            data: markdownData,
            selectable: false,
            config: theMarkdownConfigs(
              context,
              filePath: '',
              hideCodeButtons: true,
              inEditor: true,
            ),
          )
        ],
      ),
    );
  }
}
