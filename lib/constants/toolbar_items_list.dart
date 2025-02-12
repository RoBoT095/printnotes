import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolbarConfigItem {
  final String key;
  bool visible;
  final IconData icon;
  final String iconFontFamily;
  final String text;

  ToolbarConfigItem({
    required this.key,
    required this.visible,
    required this.icon,
    required this.iconFontFamily,
    required this.text,
  });

  factory ToolbarConfigItem.fromJson(Map<String, dynamic> json) {
    bool isMUIcon = json['iconFontFamily'] == 'MaterialIcons';
    return ToolbarConfigItem(
      key: json['key'],
      visible: json['visible'],
      icon: IconData(json['icon'],
          fontFamily: json['iconFontFamily'],
          fontPackage: isMUIcon ? null : 'font_awesome_flutter'),
      iconFontFamily: json['iconFontFamily'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'visible': visible,
        'icon': icon.codePoint,
        'iconFontFamily': iconFontFamily,
        'text': text,
      };
}

List<ToolbarConfigItem> defaultToolbarList = [
  ToolbarConfigItem(
    key: 'toolbar_view_item',
    visible: true,
    icon: FontAwesomeIcons.eye,
    iconFontFamily: 'FontAwesomeRegular',
    text: 'Preview',
  ),
  ToolbarConfigItem(
    key: 'toolbar_undo_redo_actions',
    visible: true,
    icon: FontAwesomeIcons.arrowRotateLeft,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Undo/Redo',
  ),
  ToolbarConfigItem(
    key: 'toolbar_selection_action',
    visible: true,
    icon: FontAwesomeIcons.textWidth,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Select current line',
  ),
  ToolbarConfigItem(
    key: 'toolbar_bold_action',
    visible: true,
    icon: FontAwesomeIcons.bold,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Make text bold',
  ),
  ToolbarConfigItem(
    key: 'toolbar_italic_action',
    visible: true,
    icon: FontAwesomeIcons.italic,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Make text italic',
  ),
  ToolbarConfigItem(
    key: 'toolbar_highlight_action',
    visible: true,
    icon: FontAwesomeIcons.highlighter,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Highlight text',
  ),
  ToolbarConfigItem(
    key: 'toolbar_strikethrough_action',
    visible: true,
    icon: FontAwesomeIcons.strikethrough,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Strikethrough text',
  ),
  ToolbarConfigItem(
    key: 'toolbar_heading_action',
    visible: true,
    icon: FontAwesomeIcons.heading,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Insert Heading',
  ),
  ToolbarConfigItem(
    key: 'toolbar_indent_action',
    visible: true,
    icon: Icons.format_indent_increase,
    iconFontFamily: 'MaterialIcons',
    text: 'Indent line',
  ),
  ToolbarConfigItem(
    key: 'toolbar_unindent_action',
    visible: true,
    icon: Icons.format_indent_decrease,
    iconFontFamily: 'MaterialIcons',
    text: 'Unindent line',
  ),
  ToolbarConfigItem(
    key: 'toolbar_unordered_list_action',
    visible: true,
    icon: FontAwesomeIcons.listUl,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Unordered list',
  ),
  ToolbarConfigItem(
    key: 'toolbar_checkbox_list_action',
    visible: true,
    icon: FontAwesomeIcons.listCheck,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Checkboxes',
  ),
  ToolbarConfigItem(
    key: 'toolbar_link_action',
    visible: true,
    icon: FontAwesomeIcons.link,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Insert hyperlink',
  ),
  ToolbarConfigItem(
    key: 'toolbar_image_action',
    visible: true,
    icon: FontAwesomeIcons.image,
    iconFontFamily: 'FontAwesomeRegular',
    text: 'Insert image',
  ),
  ToolbarConfigItem(
    key: 'toolbar_blockquote_action',
    visible: true,
    icon: FontAwesomeIcons.quoteLeft,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Blockquote',
  ),
  ToolbarConfigItem(
    key: 'toolbar_code_action',
    visible: true,
    icon: FontAwesomeIcons.code,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Code syntax/font',
  ),
  ToolbarConfigItem(
    key: 'toolbar_line_action',
    visible: true,
    icon: FontAwesomeIcons.rulerHorizontal,
    iconFontFamily: 'FontAwesomeSolid',
    text: 'Add horizontal line',
  ),
];
