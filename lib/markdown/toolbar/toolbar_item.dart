import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolbarItem extends StatelessWidget {
  const ToolbarItem({
    super.key,
    required this.icon,
    this.onPressedButton,
    this.tooltip,
    this.isExpandable = false,
    this.items,
    this.expandableBackground,
  });

  final dynamic icon;
  final VoidCallback? onPressedButton;
  final String? tooltip;
  final bool isExpandable;
  final List? items;
  final Color? expandableBackground;

  @override
  Widget build(BuildContext context) {
    return !isExpandable
        ? IconButton(
            onPressed: onPressedButton,
            splashColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            highlightColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            icon: icon is String
                ? Text(
                    icon,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : Icon(
                    icon,
                    size: 20,
                  ),
            tooltip: tooltip,
          )
        : ExpandableNotifier(
            child: Expandable(
              key: const Key("list_button"),
              collapsed: ExpandableButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon is String
                      ? Text(
                          icon,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 16,
                        ),
                ),
              ),
              expanded: Container(
                color: expandableBackground ?? Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      for (var item in items!) item,
                      ExpandableButton(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.solidCircleXmark,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
