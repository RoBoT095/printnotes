import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AppBarDragWrapper extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDragWrapper({super.key, required this.child, this.bottom = 0});

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isAndroid) {
      return child;
    }
    return DragToMoveArea(
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottom);
}
