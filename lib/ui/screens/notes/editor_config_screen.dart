import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/editor_config_provider.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';
import 'package:printnotes/constants/toolbar_items_list.dart';

class EditorConfigScreen extends StatefulWidget {
  const EditorConfigScreen({super.key});

  @override
  State<EditorConfigScreen> createState() => _EditorConfigScreenState();
}

class _EditorConfigScreenState extends State<EditorConfigScreen> {
  bool isReorderToolbar = false;

  @override
  Widget build(BuildContext context) {
    double userFontSize = context.watch<EditorConfigProvider>().fontSize;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Editor Configuration'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Config',
            Theme.of(context).colorScheme.secondary,
            padding: 10,
          ),
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
          const Divider(),
          sectionTitle(
            'Toolbar',
            Theme.of(context).colorScheme.secondary,
            padding: 10,
          ),
          ListTile(
            title: const Text('Reorder toolbar?'),
            trailing: Switch(
              value: isReorderToolbar,
              onChanged: (value) => setState(() => isReorderToolbar = value),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              primary: false,
              itemCount: toolbarConfigList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Theme.of(context).colorScheme.surfaceContainer,
                  key: ValueKey<String>(toolbarConfigList[index].key),
                  leading: Icon(toolbarConfigList[index].icon),
                  title: Text(toolbarConfigList[index].text),
                  trailing: isReorderToolbar
                      ? const Icon(Icons.drag_handle)
                      : Checkbox(
                          value: includedToolbarItems
                              .contains(toolbarConfigList[index].key),
                          onChanged: (value) {
                            if (value == true) {
                              setState(() => includedToolbarItems
                                  .add(toolbarConfigList[index].key));
                            } else {
                              setState(() => includedToolbarItems
                                  .remove(toolbarConfigList[index].key));
                            }
                          },
                        ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {},
            ),
          )
        ],
      ),
    );
  }
}
