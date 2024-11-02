import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    bool isMobile() =>
        !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS;

    Color mobileNullColor = !isMobile()
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.5);

    Future<bool> openExplorer() async {
      final path = imageFile.parent.path;
      if (Platform.isLinux) {
        Process.run("xdg-open", [path], workingDirectory: path);
      }
      if (Platform.isWindows) {
        Process.run("explorer", [path], workingDirectory: path);
      }
      if (Platform.isMacOS) {
        Process.run("open", [path], workingDirectory: path);
      }

      if (isMobile()) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Currently not supported on mobile',
              durationMil: 3000),
        );
      }

      return true;
    }

    String getFileSizeString({required int bytes, int decimals = 0}) {
      const suffixes = [" b", " kb", " mb", " gb", " tb"];
      if (bytes == 0) return '0${suffixes[0]}';
      var i = (log(bytes) / log(1024)).floor();
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
    }

    String getFormattedDate({required DateTime date}) {
      return DateFormat.yMMMd().add_jm().format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(imageFile.path.split('/').last),
        actions: [
          PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.folder_open),
                  title: const Text("Open File Location"),
                  iconColor: mobileNullColor,
                  textColor: mobileNullColor,
                ),
                onTap: () async => await openExplorer(),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
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
    );
  }
}

Widget statListTile(titleText, subtitleText) {
  return ListTile(
    title: Text(
      titleText,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    subtitle: Text(
      subtitleText,
      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      softWrap: true,
      maxLines: 2,
    ),
  );
}
