import 'package:flutter/material.dart';

import 'package:printnotes/utils/configs/data_path.dart';

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

void saveToolbarLoadout(List<ToolbarConfigItem> toolbarConfigList) {
  final Map<String, dynamic> configFileMap = DataPath.loadJsonConfigFile();

  // Object existence check for "toolbarConfig", create if null
  configFileMap['toolbarConfig'] ??= [];

  var jsonList = toolbarConfigList.map((e) => e.toJson()).toList();

  // Add to toolbar configurations to json
  configFileMap['toolbarConfig'] = jsonList;

  DataPath.saveJsonConfigFile(configFileMap);
}

List<ToolbarConfigItem>? loadToolbarLoadout() {
  final Map<String, dynamic> configFileMap = DataPath.loadJsonConfigFile();
  if (configFileMap['toolbarConfig'] != null) {
    return (configFileMap['toolbarConfig'] as List)
        .map((e) => ToolbarConfigItem.fromJson(e))
        .toList();
  }
  return null;
}
