import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/editor_config_provider.dart';
import 'package:printnotes/utils/storage_system.dart';

class CustomImgBuilder extends StatelessWidget {
  final String url;
  final String filePath;
  final Map<String, String> attributes;

  const CustomImgBuilder(this.url, this.filePath, this.attributes, {super.key});

  @override
  Widget build(BuildContext context) {
    double editorFontSize = context.watch<EditorConfigProvider>().fontSize;

    // Get image stored locally, totally fine if fails or file doesn't exist
    // as Image.file error builder will catch it
    Future<File> getLocalImage() async {
      // Check if image (url) is relative to note (filePath)
      File relativeFile = File(join(
          dirname(filePath),
          url.startsWith('.$separator')
              ? url.replaceFirst('.$separator', '')
              : url));
      if (relativeFile.existsSync()) return relativeFile;

      // Otherwise, go through all files in mainDir to find by exact name
      final allFiles = await StorageSystem.listFolderContents(
        context.read<SettingsProvider>().mainDir,
        recursive: true,
        showHidden: true,
      );
      for (FileSystemEntity item in allFiles) {
        if (item is File && basename(item.path) == url) {
          return File(item.path);
        }
      }

      // Catch for if full path was used instead
      return File(url);
    }

    Widget errorMessage(String text) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            softWrap: true,
            maxLines: 3,
            text:
                TextSpan(style: TextStyle(fontSize: editorFontSize), children: [
              WidgetSpan(
                child: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 5),
                  enableTapToDismiss: true,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.5),
                  ),
                  message: text,
                  textStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  child: Icon(
                    Icons.broken_image,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              TextSpan(
                text: ' ${attributes['alt'] ?? ''}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ]),
          ),
        );

    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            errorMessage('Image could not be loaded'),
      );
    } else {
      return FutureBuilder(
        future: getLocalImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return Image.file(
            snapshot.data != null ? snapshot.data! : File(''),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => errorMessage(
                'Incorrect path or file type, check if url is correct'),
          );
        },
      );
    }
  }
}
