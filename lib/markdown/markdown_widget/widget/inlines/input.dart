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
    int? dataLine;
    if (attr['data-line'] != null) {
      dataLine = int.tryParse(attr['data-line']!);
    }

    return WidgetSpan(
      child: config.input.builder?.call(checked) ??
          Padding(
            padding: EdgeInsets.fromLTRB(2, marginTop, 2, 0),
            child: MCheckBox(
              checked: checked,
              size: config.input.size,
              onChanged: (newValue) => config.input.onToggle
                  ?.call(CheckBoxToggleEvent(line: dataLine, checked: newValue)),
            ),
          ),
    );
  }
}

///define a function to return a checkbox widget
typedef CheckBoxBuilder = Widget Function(bool checked);

///config class for checkbox, tag: input
class CheckBoxToggleEvent {
  final int? line;
  final bool checked;
  const CheckBoxToggleEvent({this.line, required this.checked});
}

class CheckBoxConfig implements InlineConfig {
  final CheckBoxBuilder? builder;
  final double? size;
  final void Function(CheckBoxToggleEvent event)? onToggle;

  const CheckBoxConfig({this.builder, this.size, this.onToggle});

  @nonVirtual
  @override
  String get tag => MarkdownTag.input.name;
}

///the check box widget
class MCheckBox extends StatefulWidget {
  final bool checked;
  final double? size;
  final ValueChanged<bool>? onChanged;

  const MCheckBox({
    super.key,
    required this.checked,
    this.size,
    this.onChanged,
  });

  @override
  State<MCheckBox> createState() => _MCheckBoxState();
}

class _MCheckBoxState extends State<MCheckBox> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  void didUpdateWidget(covariant MCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checked != widget.checked) {
      _checked = widget.checked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size ?? 20,
      height: widget.size ?? 20,
      child: Checkbox(
        value: _checked,
        hoverColor: null,
        focusColor: null,
        splashRadius: 0,
        onChanged: (value) {
          if (value == null) return;
          setState(() => _checked = value);
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
