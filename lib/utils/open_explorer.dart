import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:printnotes/ui/widgets/custom_snackbar.dart';

bool isMobile() =>
    !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS;

Color mobileNullColor(BuildContext context) => !isMobile()
    ? Theme.of(context).colorScheme.onSurface
    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

Future<bool> openExplorer(BuildContext context, String filePath) async {
  if (Platform.isLinux) {
    Process.run("xdg-open", [filePath], workingDirectory: filePath);
  }
  if (Platform.isWindows) {
    Process.run("explorer", [filePath], workingDirectory: filePath);
  }
  if (Platform.isMacOS) {
    Process.run("open", [filePath], workingDirectory: filePath);
  }

  if (isMobile()) {
    customSnackBar('Currently not supported on mobile',
            type: 'info', durationMil: 3000)
        .show(context);
  }

  return true;
}
