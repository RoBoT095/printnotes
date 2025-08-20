import 'package:flutter/material.dart';

class CenteredPageWrapper extends StatelessWidget {
  const CenteredPageWrapper({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.decoration,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    bool isScreenLarge = MediaQuery.sizeOf(context).width >= 1000;

// Styling for desktop mode to have contents centered
    return Container(
      margin: isScreenLarge
          ? EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.sizeOf(context).width - (width ?? 800)) / 2,
              vertical: 15)
          : null,
      padding: padding,
      width: width, // 1000
      height: height,
      decoration: decoration,
      child: child,
    );
  }
}
