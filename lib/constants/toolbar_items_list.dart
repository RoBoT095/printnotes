import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:printnotes/utils/config_file/toolbar_config_handler.dart';

List<ToolbarConfigItem> defaultToolbarList = [
  ToolbarConfigItem(key: 'toolbar_view_item', visible: true),
  ToolbarConfigItem(key: 'toolbar_undo_redo_actions', visible: true),
  ToolbarConfigItem(key: 'toolbar_selection_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_bold_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_italic_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_highlight_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_strikethrough_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_heading_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_indent_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_unindent_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_unordered_list_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_checkbox_list_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_underline_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_link_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_image_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_blockquote_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_code_action', visible: true),
  ToolbarConfigItem(key: 'toolbar_line_action', visible: true),
];

final Map<String, Map<String, dynamic>> toolbarReference = {
  'toolbar_view_item': {
    'icon': FontAwesomeIcons.eye,
    'text': 'Preview',
  },
  'toolbar_undo_redo_actions': {
    'icon': FontAwesomeIcons.arrowRotateLeft,
    'text': 'Undo/Redo',
  },
  'toolbar_selection_action': {
    'icon': FontAwesomeIcons.textWidth,
    'text': 'Select current line',
  },
  'toolbar_bold_action': {
    'icon': FontAwesomeIcons.bold,
    'text': 'Make text bold',
  },
  'toolbar_italic_action': {
    'icon': FontAwesomeIcons.italic,
    'text': 'Make text italic',
  },
  'toolbar_highlight_action': {
    'icon': FontAwesomeIcons.highlighter,
    'text': 'Highlight text',
  },
  'toolbar_strikethrough_action': {
    'icon': FontAwesomeIcons.strikethrough,
    'text': 'Strikethrough text',
  },
  'toolbar_heading_action': {
    'icon': FontAwesomeIcons.heading,
    'text': 'Insert Heading',
  },
  'toolbar_indent_action': {
    'icon': Icons.format_indent_increase,
    'text': 'Indent line',
  },
  'toolbar_unindent_action': {
    'icon': Icons.format_indent_decrease,
    'text': 'Unindent line',
  },
  'toolbar_unordered_list_action': {
    'icon': FontAwesomeIcons.listUl,
    'text': 'Unordered list',
  },
  'toolbar_checkbox_list_action': {
    'icon': FontAwesomeIcons.listCheck,
    'text': 'Checkboxes',
  },
  'toolbar_underline_action': {
    'icon': FontAwesomeIcons.underline,
    'text': 'Underline text',
  },
  'toolbar_link_action': {
    'icon': FontAwesomeIcons.link,
    'text': 'Insert hyperlink',
  },
  'toolbar_image_action': {
    'icon': FontAwesomeIcons.image,
    'text': 'Insert image',
  },
  'toolbar_blockquote_action': {
    'icon': FontAwesomeIcons.quoteLeft,
    'text': 'Blockquote',
  },
  'toolbar_code_action': {
    'icon': FontAwesomeIcons.code,
    'text': 'Code syntax/font',
  },
  'toolbar_line_action': {
    'icon': FontAwesomeIcons.rulerHorizontal,
    'text': 'Add horizontal line',
  },
};
