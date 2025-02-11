import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolbarConfigItem {
  final String key;
  final IconData icon;
  final String text;

  ToolbarConfigItem({
    required this.key,
    required this.icon,
    required this.text,
  });
}

List<ToolbarConfigItem> toolbarConfigList = [
  ToolbarConfigItem(
    key: 'toolbar_view_item',
    icon: FontAwesomeIcons.eye,
    text: 'Preview',
  ),
  ToolbarConfigItem(
    key: 'toolbar_undo_redo_actions',
    icon: FontAwesomeIcons.arrowRotateLeft,
    text: 'Undo/Redo',
  ),
  ToolbarConfigItem(
    key: 'toolbar_selection_action',
    icon: FontAwesomeIcons.textWidth,
    text: 'Select current line',
  ),
  ToolbarConfigItem(
    key: 'toolbar_bold_action',
    icon: FontAwesomeIcons.bold,
    text: 'Make text bold',
  ),
  ToolbarConfigItem(
    key: 'toolbar_italic_action',
    icon: FontAwesomeIcons.italic,
    text: 'Make text italic',
  ),
  ToolbarConfigItem(
    key: 'toolbar_highlight_action',
    icon: FontAwesomeIcons.highlighter,
    text: 'Highlight text',
  ),
  ToolbarConfigItem(
    key: 'toolbar_strikethrough_action',
    icon: FontAwesomeIcons.strikethrough,
    text: 'Strikethrough text',
  ),
  ToolbarConfigItem(
    key: 'toolbar_heading_action',
    icon: FontAwesomeIcons.heading,
    text: 'Insert Heading',
  ),
  ToolbarConfigItem(
    key: 'toolbar_indent_action',
    icon: Icons.format_indent_increase,
    text: 'Indent line',
  ),
  ToolbarConfigItem(
    key: 'toolbar_unindent_action',
    icon: Icons.format_indent_decrease,
    text: 'Unindent line',
  ),
  ToolbarConfigItem(
    key: 'toolbar_unordered_list_action',
    icon: FontAwesomeIcons.listUl,
    text: 'Unordered list',
  ),
  ToolbarConfigItem(
    key: 'toolbar_checkbox_list_action',
    icon: FontAwesomeIcons.listCheck,
    text: 'Checkboxes',
  ),
  ToolbarConfigItem(
    key: 'toolbar_link_action',
    icon: FontAwesomeIcons.link,
    text: 'Insert hyperlink',
  ),
  ToolbarConfigItem(
    key: 'toolbar_image_action',
    icon: FontAwesomeIcons.image,
    text: 'Insert image',
  ),
  ToolbarConfigItem(
    key: 'toolbar_blockquote_action',
    icon: FontAwesomeIcons.quoteLeft,
    text: 'Blockquote',
  ),
  ToolbarConfigItem(
    key: 'toolbar_code_action',
    icon: FontAwesomeIcons.code,
    text: 'Code syntax/font',
  ),
  ToolbarConfigItem(
    key: 'toolbar_line_action',
    icon: FontAwesomeIcons.rulerHorizontal,
    text: 'Add horizontal line',
  ),
];

List<String> includedToolbarItems = [
  'toolbar_view_item',
  'toolbar_undo_redo_actions',
  'toolbar_selection_action',
  'toolbar_bold_action',
  'toolbar_italic_action',
  'toolbar_highlight_action',
  'toolbar_strikethrough_action',
  'toolbar_heading_action',
  'toolbar_indent_action',
  'toolbar_unindent_action',
  'toolbar_unordered_list_action',
  'toolbar_checkbox_list_action',
  'toolbar_link_action',
  'toolbar_image_action',
  'toolbar_blockquote_action',
  'toolbar_code_action',
  'toolbar_line_action',
];
