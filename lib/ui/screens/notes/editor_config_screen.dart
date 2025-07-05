import 'package:flutter/material.dart';
import 'package:printnotes/constants/toolbar_items_list.dart';
import 'package:printnotes/utils/config_file/toolbar_config_handler.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/editor_config_provider.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';
import 'package:printnotes/markdown/toolbar/markdown_toolbar.dart';

class EditorConfigScreen extends StatelessWidget {
  const EditorConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double userFontSize = context.watch<EditorConfigProvider>().fontSize;
    bool isEditingToolbar = context.watch<EditorConfigProvider>().isEditing;

    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          title: const Text('Editor Configuration'),
        ),
      ),
      body: ListView(
        primary: true,
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
            title: const Text('Edit Toolbar?'),
            trailing: Switch(
                value: isEditingToolbar,
                onChanged: context.read<EditorConfigProvider>().setIsEditing),
          ),
          const Divider(),
          MarkdownToolbar(
            controller: TextEditingController(),
            onPreviewChanged: () {},
            undoController: UndoHistoryController(),
            toolbarBackground: Theme.of(context).colorScheme.surfaceContainer,
            expandableBackground: Theme.of(context).colorScheme.surface,
            userToolbarItemList:
                context.watch<EditorConfigProvider>().toolbarItemList,
            absorbOnTap: true,
          ),
          if (isEditingToolbar)
            const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Include'), Text('Reorder')],
              ),
            ),
          AbsorbPointer(
            absorbing: !isEditingToolbar,
            child: ReorderableListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount:
                  context.watch<EditorConfigProvider>().toolbarItemList.length,
              itemBuilder: (context, index) {
                List<ToolbarConfigItem> toolbarList =
                    context.watch<EditorConfigProvider>().toolbarItemList;
                return ListTile(
                  key: ValueKey<String>(toolbarList[index].key),
                  leading: isEditingToolbar
                      ? Checkbox(
                          value: toolbarList[index].visible,
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<EditorConfigProvider>()
                                  .setToolbarItemVisibility(value, index);
                            }
                          },
                        )
                      : null,
                  title: Row(
                    children: [
                      Icon(toolbarReference[toolbarList[index].key]!['icon']),
                      const SizedBox(width: 15),
                      Text(toolbarReference[toolbarList[index].key]!['text']),
                    ],
                  ),
                  trailing:
                      isEditingToolbar ? const Icon(Icons.drag_handle) : null,
                );
              },
              onReorder: context.read<EditorConfigProvider>().updateListOrder,
            ),
          ),
        ],
      ),
    );
  }
}
