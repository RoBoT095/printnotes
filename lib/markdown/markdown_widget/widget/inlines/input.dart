import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/configs.dart';
import '../span_node.dart';

///Tag: [MarkdownTag.input]
class InputNode extends SpanNode {
  final Map<String, String> attr;
  final MarkdownConfig config;

  InputNode(this.attr, this.config);

  @override
  InlineSpan build() {
    bool checked = false;
    if (attr['checked'] != null) {
      checked = attr['checked']!.toLowerCase() == 'true';
    }
    final parentStyleHeight =
        (parentStyle?.fontSize ?? config.p.textStyle.fontSize ?? 16.0) *
            (parentStyle?.height ?? config.p.textStyle.height ?? 1.5);
    final marginTop = max((parentStyleHeight / 2) - 12, 0.0);
    return WidgetSpan(
      child: config.input.builder?.call(checked) ??
          Padding(
            padding: EdgeInsets.fromLTRB(2, marginTop, 2, 0),
            child: MCheckBox(checked: checked),
          ),
    );
  }
}

///define a function to return a checkbox widget
typedef CheckBoxBuilder = Widget Function(bool checked);

///config class for checkbox, tag: input
class CheckBoxConfig implements InlineConfig {
  final CheckBoxBuilder? builder;
  final double? size;

  const CheckBoxConfig({this.builder, this.size});

  @nonVirtual
  @override
  String get tag => MarkdownTag.input.name;
}

///the check box widget
class MCheckBox extends StatelessWidget {
  final bool checked;
  final double? size;

  const MCheckBox({
    super.key,
    required this.checked,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 20,
      height: size ?? 20,
      child: Checkbox(
        value: checked,
        hoverColor: null,
        focusColor: null,
        splashRadius: 0,
        onChanged: (value) {},
      ),
    );
  }
}
