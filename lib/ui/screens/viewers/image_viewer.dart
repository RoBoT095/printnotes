import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import 'package:printnotes/utils/file_info.dart';
import 'package:printnotes/utils/open_explorer.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageUri});

  final Uri imageUri;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isScreenLarge = screenWidth >= 600;

    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          centerTitle: true,
          title: SelectableText(
            path.basename(imageUri.toFilePath()),
            maxLines: 1,
          ),
          actions: [
            PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (context) => <PopupMenuEntry>[
                if (!Platform
                    .isLinux) // Currently, files not supported by SharePlus
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.share),
                      title: Text('Share'),
                      onTap: () {
                        SharePlus.instance.share(
                            ShareParams(files: [XFile(imageUri.toFilePath())]));
                      },
                    ),
                  ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.folder_open),
                    title: const Text("Open Location"),
                    iconColor: mobileNullColor(context),
                    textColor: mobileNullColor(context),
                  ),
                  onTap: () async =>
                      await openExplorer(context, imageUri.toFilePath()),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: isScreenLarge
              ? EdgeInsets.symmetric(horizontal: (screenWidth - 600) / 2)
              : null,
          child: Column(
            children: [
              Image.file(File.fromUri(imageUri)),
              statListTile(
                  'File Size: ',
                  getFileSizeString(
                      bytes: File.fromUri(imageUri).statSync().size)),
              statListTile(
                  'Last Modified: ',
                  getFormattedDate(
                      date: File.fromUri(imageUri).statSync().modified)),
              statListTile('Location: ', imageUri.toFilePath()),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
