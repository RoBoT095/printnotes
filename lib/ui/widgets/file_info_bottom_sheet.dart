import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printnotes/utils/file_info.dart';

Future modalShowFileInfo(BuildContext context, Uri fileUri) =>
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        File file = File.fromUri(fileUri);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            statListTile('Character Count:', getCharacterCount(fileUri)),
            statListTile('Word Count:', getWordCount(fileUri)),
            statListTile(
                'File Size:', getFileSizeString(bytes: file.statSync().size)),
            statListTile('Last Modified:',
                getFormattedDate(date: file.statSync().modified)),
            statListTile('Location:', fileUri.toFilePath()),
            const SizedBox(height: 50)
          ],
        );
      },
    );
