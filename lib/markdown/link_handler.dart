import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/utils/storage_system.dart';

Future<void> linkHandler(BuildContext context, String url) async {
  String? jumpToHeader;
  if (url.contains('&jumpToHeader=')) {
    int headerIndex = url.indexOf('&jumpToHeader=');
    if (headerIndex != -1) {
      String header = url.substring(headerIndex + 14).trim();
      if (header.contains('|')) {
        int pipeIndex = header.lastIndexOf('|');
        if (pipeIndex != -1) {
          jumpToHeader = header.substring(0, pipeIndex).trim();
        }
      } else {
        jumpToHeader = header;
      }
      url = url.substring(0, headerIndex).trim();
    }
  }
  Uri parsedUri = Uri.parse(url);
  if (parsedUri.hasAbsolutePath) {
    launchUrl(parsedUri);
  } else {
    final allFiles = await StorageSystem.listFolderContents(
      context.read<SettingsProvider>().mainDir,
      recursive: true,
      showHidden: true,
    );

    for (FileSystemEntity item in allFiles) {
      String baseFile = basename(item.path).toLowerCase();
      if (item is File &&
          baseFile.contains(url.toLowerCase()) &&
          context.mounted) {
        context
            .read<NavigationProvider>()
            .routeItemToPage(context, item, jumpToHeader: jumpToHeader);
        break;
      }
    }
  }
}
