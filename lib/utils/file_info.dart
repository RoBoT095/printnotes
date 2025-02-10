import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

String getCharacterCount(String filePath) {
  File file = File(filePath);
  String fileString = file.readAsStringSync();
  return fileString.length.toString();
}

String getWordCount(String filePath) {
  File file = File(filePath);
  String fileString = file.readAsStringSync();
  int wordCount =
      RegExp(r'[\w._]+').allMatches(fileString.replaceAll('\n', ' ')).length;
  return wordCount.toString();
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = [" B", " KiB", " MiB", " GiB", " TiB"];
  if (bytes == 0) return '0${suffixes[0]}';
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

String getFormattedDate({required DateTime date}) {
  return DateFormat.yMMMd().add_jm().format(date);
}

Widget statListTile(titleText, subtitleText) {
  return ListTile(
    title: Text(
      titleText,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    subtitle: Text(
      subtitleText,
      style: const TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),
      softWrap: true,
      maxLines: 3,
    ),
  );
}
