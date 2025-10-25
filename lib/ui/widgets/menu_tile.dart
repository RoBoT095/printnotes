import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final bool enabled;
  final String? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isFirst;
  final bool isLast;
  final BoxDecoration? decoration;
  final Color? iconColor;
  final Color? bgColor;

  const MenuTile({
    super.key,
    this.enabled = true,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isFirst = false,
    this.isLast = false,
    this.decoration,
    this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.fromLTRB(2.0, isFirst ? 2.0 : 0, 2.0, isLast ? 2.0 : 0),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(15) : Radius.zero,
          bottom: isLast ? const Radius.circular(15) : Radius.zero,
        ),
      ).copyWith(
        color: decoration?.color,
        image: decoration?.image,
        border: decoration?.border,
        borderRadius: decoration?.borderRadius,
        backgroundBlendMode: decoration?.backgroundBlendMode,
        boxShadow: decoration?.boxShadow,
        gradient: decoration?.gradient,
        shape: decoration?.shape,
      ),
      child: ListTile(
        iconColor: iconColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(15) : Radius.zero,
            topRight: isFirst ? const Radius.circular(15) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(15) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(15) : Radius.zero,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        enabled: enabled,
        leading: leading,
        title: title != null
            ? Text(
                title!,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: enabled == false
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).colorScheme.onSurface),
              )
            : null,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  static Widget subtitleText(BuildContext context,
      {required String text, bool enabled = true}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: enabled == false
            ? Theme.of(context).disabledColor
            : Theme.of(context).colorScheme.onSurface.withAlpha(128),
      ),
    );
  }
}
