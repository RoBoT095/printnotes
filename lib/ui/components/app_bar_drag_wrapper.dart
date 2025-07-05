import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AppBarDragWrapper extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDragWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
