import 'dart:io';

import 'package:flutter/material.dart';

import 'package:printnotes/utils/file_info.dart';
import 'package:printnotes/utils/open_explorer.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isScreenLarge = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SelectableText(
          imageFile.path.split('/').last,
          maxLines: 1,
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.folder_open),
                  title: const Text("Open Location"),
                  iconColor: mobileNullColor(context),
                  textColor: mobileNullColor(context),
                ),
                onTap: () async =>
                    await openExplorer(context, imageFile.parent.path),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: isScreenLarge
              ? EdgeInsets.symmetric(horizontal: (screenWidth - 600) / 2)
              : null,
          child: Column(
            children: [
              Image.file(imageFile),
              statListTile('File Size: ',
                  getFileSizeString(bytes: imageFile.statSync().size)),
              statListTile('Last Modified: ',
                  getFormattedDate(date: imageFile.statSync().modified)),
              statListTile('Location: ', imageFile.path),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
