import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/editor_config_provider.dart';
// import 'package:printnotes/ui/widgets/list_section_title.dart';

class EditorConfigScreen extends StatelessWidget {
  const EditorConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double userFontSize = context.watch<EditorConfigProvider>().fontSize;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Editor Configuration'),
      ),
      body: ListView(
        children: [
          // sectionTitle(
          //   'Config',
          //   Theme.of(context).colorScheme.secondary,
          //   padding: 10,
          // ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: Icon(Icons.font_download, size: userFontSize),
            title: Text(
              'Font Size',
              style: TextStyle(fontSize: userFontSize),
            ),
            trailing: DropdownButton(
                value: userFontSize,
                items: const [
                  DropdownMenuItem(value: 12, child: Text('12px')),
                  DropdownMenuItem(value: 16, child: Text('16px (Default)')),
                  DropdownMenuItem(value: 20, child: Text('20px')),
                  DropdownMenuItem(value: 24, child: Text('24px')),
                  DropdownMenuItem(value: 28, child: Text('28px')),
                  DropdownMenuItem(value: 32, child: Text('32px')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<EditorConfigProvider>()
                        .setFontSize(value.toDouble());
                  }
                }),
          ),
          // const Divider(),
          // sectionTitle(
          //   'Toolbar',
          //   Theme.of(context).colorScheme.secondary,
          //   padding: 10,
          // ),
        ],
      ),
    );
  }
}
