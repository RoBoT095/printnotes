import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:printnotes/utils/config_file/toolbar_config_handler.dart';

import 'toolbar.dart';
import 'modal_input_url.dart';
import 'toolbar_item.dart';

class MarkdownToolbar extends StatelessWidget {
  MarkdownToolbar({
    super.key,
    required this.onPreviewChanged,
    required this.controller,
    required this.undoController,
    this.onValueChange,
    this.toolbarBackground,
    this.expandableBackground,
    this.userToolbarItemList,
    this.absorbOnTap = false,
  }) : toolbar = Toolbar(controller: controller, onValueChange: onValueChange);

  final VoidCallback onPreviewChanged;
  final TextEditingController controller;
  final UndoHistoryController undoController;
  final Toolbar toolbar;
  final ValueChanged<bool>? onValueChange;
  final Color? toolbarBackground;
  final Color? expandableBackground;
  final List<ToolbarConfigItem>? userToolbarItemList;
  final bool absorbOnTap;

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> allToolbarItems = <String, Widget>{
      // preview
      'toolbar_view_item': ToolbarItem(
        key: const ValueKey<String>("toolbar_view_item"),
        icon: FontAwesomeIcons.eye,
        tooltip: 'Show/Hide markdown preview',
        onPressedButton: () {
          onPreviewChanged.call();
        },
      ),
      'toolbar_undo_redo_actions': ValueListenableBuilder(
        key: const ValueKey<String>("toolbar_undo_redo_actions"),
        valueListenable: undoController,
        builder: (context, value, child) {
          return Row(
            children: [
              // undo
              ToolbarItem(
                key: const ValueKey<String>("toolbar_undo_action"),
                icon: FontAwesomeIcons.arrowRotateLeft,
                tooltip: 'Undo previous action',
                onPressedButton:
                    value.canUndo ? () => undoController.undo() : null,
              ),
              // redo
              ToolbarItem(
                key: const ValueKey<String>("toolbar_redo_action"),
                icon: FontAwesomeIcons.arrowRotateRight,
                tooltip: 'Redo previous action',
                onPressedButton:
                    value.canRedo ? () => undoController.redo() : null,
              ),
            ],
          );
        },
      ),
      // select single line
      'toolbar_selection_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_selection_action"),
        icon: FontAwesomeIcons.textWidth,
        tooltip: 'Select single line',
        onPressedButton: () {
          toolbar.selectSingleLine();
        },
      ),
      // bold
      'toolbar_bold_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_bold_action"),
        icon: FontAwesomeIcons.bold,
        tooltip: 'Make text bold',
        onPressedButton: () {
          toolbar.action("**", "**");
        },
      ),
      // italic
      'toolbar_italic_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_italic_action"),
        icon: FontAwesomeIcons.italic,
        tooltip: 'Make text italic',
        onPressedButton: () {
          toolbar.action("_", "_");
        },
      ),
      // highlighter
      'toolbar_highlight_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_highlight_action"),
        icon: FontAwesomeIcons.highlighter,
        tooltip: 'Highlight text',
        onPressedButton: () {
          toolbar.action("==", "==");
        },
      ),
      // strikethrough
      'toolbar_strikethrough_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_strikethrough_action"),
        icon: FontAwesomeIcons.strikethrough,
        tooltip: 'Strikethrough text',
        onPressedButton: () {
          toolbar.action("~~", "~~");
        },
      ),
      // heading
      'toolbar_heading_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_heading_action"),
        icon: FontAwesomeIcons.heading,
        isExpandable: true,
        tooltip: 'Insert Heading',
        expandableBackground: expandableBackground,
        items: [
          ToolbarItem(
            key: const ValueKey<String>("h1"),
            icon: "H1",
            tooltip: 'Insert Heading 1',
            onPressedButton: () => toolbar.action("# ", ""),
          ),
          ToolbarItem(
            key: const ValueKey<String>("h2"),
            icon: "H2",
            tooltip: 'Insert Heading 2',
            onPressedButton: () => toolbar.action("## ", ""),
          ),
          ToolbarItem(
            key: const ValueKey<String>("h3"),
            icon: "H3",
            tooltip: 'Insert Heading 3',
            onPressedButton: () => toolbar.action("### ", ""),
          ),
        ],
      ),
      // indent
      'toolbar_indent_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_indent_action"),
        icon: Icons.format_indent_increase,
        tooltip: 'Indent line',
        onPressedButton: () {
          toolbar.action("  ", "");
        },
      ),
      // unindent
      'toolbar_unindent_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_unindent_action"),
        icon: Icons.format_indent_decrease,
        tooltip: 'Unindent',
        onPressedButton: () {
          toolbar.action("", "  ");
        },
      ),
      // unordered list
      'toolbar_unordered_list_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_unordered_list_action"),
        icon: FontAwesomeIcons.listUl,
        tooltip: 'Unordered list',
        onPressedButton: () {
          toolbar.action("- ", "");
        },
      ),
      // checkbox list
      'toolbar_checkbox_list_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_checkbox_list_action"),
        icon: FontAwesomeIcons.listCheck,
        isExpandable: true,
        expandableBackground: expandableBackground,
        items: [
          ToolbarItem(
            key: const ValueKey<String>("checkbox"),
            icon: FontAwesomeIcons.solidSquareCheck,
            tooltip: 'Checked checkbox',
            onPressedButton: () {
              toolbar.action("- [x] ", "");
            },
          ),
          ToolbarItem(
            key: const ValueKey<String>("uncheckbox"),
            icon: FontAwesomeIcons.square,
            tooltip: 'Unchecked checkbox',
            onPressedButton: () {
              toolbar.action("- [ ] ", "");
            },
          )
        ],
      ),
      // underline
      'toolbar_underline_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_underline_action"),
        icon: FontAwesomeIcons.underline,
        tooltip: 'Underline text',
        onPressedButton: () {
          toolbar.action("__", "__");
        },
      ),
      // link
      'toolbar_link_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_link_action"),
        icon: FontAwesomeIcons.link,
        tooltip: 'Add hyperlink',
        onPressedButton: () async {
          if (toolbar.hasSelection) {
            toolbar.action("[enter link description here](", ")");
          } else {
            await _showModalInputUrl(context, "[enter link description here](",
                controller.selection);
          }
        },
      ),
      // image
      'toolbar_image_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_image_action"),
        icon: FontAwesomeIcons.image,
        tooltip: 'Add image',
        onPressedButton: () async {
          if (toolbar.hasSelection) {
            toolbar.action("![enter image description here](", ")");
          } else {
            await _showModalInputUrl(
              context,
              "![enter image description here](",
              controller.selection,
            );
          }
        },
      ),
      // blockquote
      'toolbar_blockquote_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_blockquote_action"),
        icon: FontAwesomeIcons.quoteLeft,
        tooltip: 'Blockquote',
        onPressedButton: () {
          toolbar.action("> ", "");
        },
      ),
      // code
      'toolbar_code_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_code_action"),
        icon: FontAwesomeIcons.code,
        tooltip: 'Code syntax/font',
        onPressedButton: () {
          toolbar.action("`", "`");
        },
      ),
      // line
      'toolbar_line_action': ToolbarItem(
        key: const ValueKey<String>("toolbar_line_action"),
        icon: FontAwesomeIcons.rulerHorizontal,
        tooltip: 'Add line',
        onPressedButton: () {
          toolbar.action("\n___\n", "");
        },
      ),
    };
    List<Widget> returnedToolList = [];
    if (userToolbarItemList != null && userToolbarItemList != []) {
      for (ToolbarConfigItem item in userToolbarItemList!) {
        if (item.visible) returnedToolList.add(allToolbarItems[item.key]!);
      }
    } else {
      returnedToolList =
          allToolbarItems.entries.map((entry) => entry.value).toList();
    }
    return Container(
      color: toolbarBackground ?? Colors.grey[200],
      width: double.infinity,
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: AbsorbPointer(
          absorbing: absorbOnTap,
          child: Row(
            children: returnedToolList,
          ),
        ),
      ),
    );
  }

  // show modal input
  Future<dynamic> _showModalInputUrl(
    BuildContext context,
    String leftText,
    TextSelection selection,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ModalInputUrl(
          toolbar: toolbar,
          leftText: leftText,
          selection: selection,
        );
      },
    );
  }
}
