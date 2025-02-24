import 'package:printnotes/utils/configs/data_path.dart';

class ToolbarConfigItem {
  final String key;
  bool visible;

  ToolbarConfigItem({
    required this.key,
    required this.visible,
  });

  factory ToolbarConfigItem.fromJson(Map<String, dynamic> json) {
    return ToolbarConfigItem(
      key: json['key'],
      visible: json['visible'],
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'visible': visible,
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
