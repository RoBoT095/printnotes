import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
// import 'package:docman/docman.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/customization_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/utils/parsers/csv_parser.dart';
import 'package:printnotes/utils/parsers/frontmatter_parser.dart';

/// Used by [StorageSystem.searchItem] with [StorageSystem.searchMultiFileContents]
class SearchPayload {
  final String query;
  final List<File> files;

  SearchPayload({required this.query, required this.files});
}

// The Abomination File that handles everything related to folders on the device
// better to rewrite and clean up everything but this sand castle is already held by hot glue
// and it can only grow now
class StorageSystem {
  final BuildContext context;

  StorageSystem(this.context);

  // For searching

  Future<List<FileSystemEntity>> searchItems(String query) async {
    final String mainDir = context.read<SettingsProvider>().mainDir;
    List<FileSystemEntity> allItems = await StorageSystem.listFolderContents(
        Uri.parse(mainDir),
        recursive: true);

    final List<FileSystemEntity> filteredItems = allItems.where((item) {
      return fileTypeChecker(item.path) == CFileType.note;
    }).toList();

    List<FileSystemEntity> results = [];
    query = query.toLowerCase();

    // First match by name
    results = filteredItems
        .where((item) => path.basename(item.path.toLowerCase()).contains(query))
        .toList();

    // Isolate files for compute
    final List<File> files = filteredItems.map((e) => File(e.path)).toList();

    // Multi-threading search baby (idk how this all works >.<)
    final List<File> matchedFiles = await compute(
        searchMultiFileContents, SearchPayload(query: query, files: files));

    // Merge files found by name and contents, avoids duplicates
    final Set<String> pathSet = results.map((e) => e.path).toSet();
    for (File file in matchedFiles) {
      if (!pathSet.contains(file.path)) {
        results.add(file);
      }
    }

    return results;
  }

  /// Used by [searchItem] with compute
  // and I don't know if it should be used by other function
  // idr if this is duplicate code
  static List<File> searchMultiFileContents(SearchPayload payload) {
    final query = payload.query;
    final files = payload.files;
    final List<File> results = [];

    // Loop through files and check contents
    for (File file in files) {
      if (!file.existsSync()) continue;

      final content =
          file.readAsStringSync().replaceAll('\n', ' ').toLowerCase();

      // Files that match by their contents
      if (content.contains(query)) {
        results.add(file);
        continue;
      }

      // TODO: Display the tag maybe?

      // If files have tags, check em
      if (query.contains('tags:')) {
        final List<RegExpMatch> tags =
            RegExp(r'#\w+').allMatches(content).toList();
        final String cleanQuery = query.replaceFirst('tags:', '').trim();

        if (tags.isNotEmpty) {
          // Display all files with tags
          if (cleanQuery.isEmpty) {
            results.add(file);
            // Display searched files with tags
          } else if (tags.any(
              (e) => content.substring(e.start, e.end).contains(cleanQuery))) {
            results.add(file);
          }
        }
      }
    }

    return results;
  }

  static Future<Map<String, List<String>>> getAllTags(String mainDir) async {
    List<FileSystemEntity> allItems = await StorageSystem.listFolderContents(
        Uri.parse(mainDir),
        recursive: true);

    final List<FileSystemEntity> filteredItems = allItems.where((item) {
      return fileTypeChecker(item.path) == CFileType.note;
    }).toList();

    // Isolate files for compute
    final List<File> files = filteredItems.map((e) => File(e.path)).toList();

    final List<File> matchedFiles = await compute(
        searchMultiFileContents, SearchPayload(query: 'tags:', files: files));

    final Map<String, List<String>> tagMap = {};

    for (File file in matchedFiles) {
      if (!file.existsSync()) continue;

      String contents = await file.readAsString();

      final matches = RegExp(r'^\s*(#\w+)').allMatches(contents);

      for (final match in matches) {
        final tag = contents.substring(match.start, match.end);

        tagMap.putIfAbsent(tag, () => []);

        if (!tagMap[tag]!.contains(file.path)) {
          tagMap[tag]!.add(file.path);
        }
      }
    }
    return tagMap;
  }

  // Methods for archiving

  static Future<void> unarchiveItem(String archivedItemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final archiveDir = path.join(baseDir!, '.archive');
    final relativePath = path.relative(archivedItemPath, from: archiveDir);
    final destinationPath = path.join(baseDir, relativePath);

    final archivedItem = FileSystemEntity.typeSync(archivedItemPath) ==
            FileSystemEntityType.directory
        ? Directory(archivedItemPath)
        : File(archivedItemPath);

    final destinationItem = FileSystemEntity.typeSync(archivedItemPath) ==
            FileSystemEntityType.directory
        ? Directory(destinationPath)
        : File(destinationPath);

    await destinationItem.parent.create(recursive: true);

    if (archivedItem is Directory) {
      await _copyDirectory(
          archivedItem.uri, (destinationItem as Directory).uri);
    } else {
      await (archivedItem as File).copy(destinationItem.path);
    }

    // Delete the archived item after unarchiving
    await archivedItem.delete(recursive: true);
  }

  static Future<void> archiveItem(Uri itemUri) async {
    final baseDir = await DataPath.selectedDirectory;
    final archiveDir = path.join(baseDir!, '.archive');
    final relativePath = path.relative(itemUri.toFilePath(), from: baseDir);
    final archivePath = path.join(archiveDir, relativePath);

    final sourceItem = await FileSystemEntity.isDirectory(itemUri.toFilePath())
        ? Directory.fromUri(itemUri)
        : File.fromUri(itemUri);

    final archiveItem = await FileSystemEntity.isDirectory(itemUri.toFilePath())
        ? Directory(archivePath)
        : File(archivePath);

    await archiveItem.parent.create(recursive: true);

    if (sourceItem is Directory) {
      await _copyDirectory(sourceItem.uri, Directory(archiveItem.path).uri);
    } else {
      await File(sourceItem.path).copy(archiveItem.path);
    }

    // Delete the original item after archiving
    await sourceItem.delete(recursive: true);
  }

  static Future<void> _copyDirectory(Uri sourceUri, Uri destinationUri) async {
    final source = Directory.fromUri(sourceUri);
    final destination = Directory.fromUri(destinationUri);

    await destination.create(recursive: true);

    await for (FileSystemEntity entity in source.list(recursive: false)) {
      if (entity is Directory) {
        Directory newDirectory =
            Directory(path.join(destination.path, path.basename(entity.path)));
        await _copyDirectory(entity.uri, newDirectory.uri);
      } else if (entity is File) {
        await entity
            .copy(path.join(destination.path, path.basename(entity.path)));
      }
    }
  }

  // Prevent user from creating or rename item with existing name
  static Future<bool> nameExists(String name, {String? parentPath}) async {
    final baseDir = parentPath ?? await DataPath.selectedDirectory;
    final fullPath = path.join(baseDir!, name);
    final fileExists = await File('$fullPath.md').exists();
    final folderExists = await Directory(fullPath).exists();
    return fileExists || folderExists;
  }

  // Methods related to creating, loading, and saving files

  static Future<String> createFile(String fileName,
      {String? parentPath}) async {
    final baseDir = parentPath ?? await DataPath.selectedDirectory;
    if (await nameExists(fileName, parentPath: baseDir)) {
      throw Exception('A file or folder with this name already exists.');
    }
    String ext = path.extension(fileName);
    final filePath =
        path.join(baseDir!, ext.isEmpty ? '$fileName.md' : fileName);
    File(filePath).create(recursive: true);
    return filePath;
  }

  static Future<String> loadFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }

  Future<String> getFilePreview(
    Uri fileUri, {
    bool parseFrontmatter = false,
    bool isTrimmed = true,
  }) async {
    try {
      int previewLength = context.read<CustomizationProvider>().previewLength;
      final file = File.fromUri(fileUri);
      if (await file.exists()) {
        String content = await file.readAsString();
        if (parseFrontmatter) {
          final doc = FrontmatterHandleParsing.getParsedData(content);
          if (doc != null) content = doc.body;
        }

        // Limit to previewLength then trim whitespace
        if (isTrimmed) {
          String trimmedContent = content
              .substring(
                  0,
                  content.length < previewLength
                      ? content.length
                      : previewLength)
              .trim();

          if (fileUri.toFilePath().endsWith('csv')) {
            trimmedContent = csvToMarkdownTable(trimmedContent);
          }
          return trimmedContent;
        } else {
          return content;
        }
      }
    } catch (e) {
      debugPrint('Error reading file: $e');
    }
    return 'No preview available';
  }

  // Method to duplicate Items (not folders)
  // adds (num) to end of name, continues adding up if a copy already exists
  static Future<String> duplicateItem(String originalPath) async {
    final dir = path.dirname(originalPath);
    final ext = path.extension(originalPath);
    String baseName = path.basenameWithoutExtension(originalPath);

    final regex = RegExp(r'^(.*)\((\d+)\)$');
    int copyNumber = 1;

    // Check for if the filename already ends with (num)
    final match = regex.firstMatch(baseName);
    if (match != null) {
      baseName = match.group(1)!.trim(); // remove (num)
      copyNumber = int.parse(match.group(2)!) + 1;
    }

    String newName = '$baseName($copyNumber)';
    String newPath = path.join(dir, '$newName$ext');

    while (await File(newPath).exists()) {
      copyNumber++;
      newName = '$baseName($copyNumber)';
      newPath = path.join(dir, '$newName$ext');
    }

    final originalFile = File(originalPath);
    await originalFile.copy(newPath);

    return newPath;
  }

  // Methods related to creating folders

  static Future<String> createFolder(String folderName,
      {String? parentPath}) async {
    final baseDir = parentPath ?? await DataPath.selectedDirectory;
    if (await nameExists(folderName, parentPath: baseDir)) {
      throw Exception('A file or folder with this name already exists.');
    }
    final newFolder = Directory(path.join(baseDir!, folderName));
    if (!await newFolder.exists()) {
      await newFolder.create(recursive: true);
    }
    return newFolder.path;
  }

  // Methods to trash and permanent delete

  static Future<void> trashItem(String itemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final deleteDir = path.join(baseDir!, '.trash');
    final relativePath = path.relative(itemPath, from: baseDir);
    final itemName = path.basename(itemPath);
    final deletedPath =
        path.join(deleteDir, path.dirname(relativePath), itemName);

    final sourceItem =
        FileSystemEntity.typeSync(itemPath) == FileSystemEntityType.directory
            ? Directory(itemPath)
            : File(itemPath);

    final deletedItem =
        FileSystemEntity.typeSync(itemPath) == FileSystemEntityType.directory
            ? Directory(deletedPath)
            : File(deletedPath);

    await deletedItem.parent.create(recursive: true);

    if (sourceItem is Directory) {
      await _copyDirectory(sourceItem.uri, (deletedItem as Directory).uri);
    } else {
      await (sourceItem as File).copy(deletedItem.path);
    }

    // Delete the original item after moving to .trash
    await sourceItem.delete(recursive: true);
  }

  static Future<void> restoreDeletedItem(String deletedItemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final deleteDir = path.join(baseDir!, '.trash');
    final itemName = path.basename(deletedItemPath);
    final relativePath =
        path.relative(path.dirname(deletedItemPath), from: deleteDir);
    final destinationPath = path.join(baseDir, relativePath, itemName);

    final deletedItem = FileSystemEntity.typeSync(deletedItemPath) ==
            FileSystemEntityType.directory
        ? Directory(deletedItemPath)
        : File(deletedItemPath);

    final destinationItem = FileSystemEntity.typeSync(deletedItemPath) ==
            FileSystemEntityType.directory
        ? Directory(destinationPath)
        : File(destinationPath);

    await destinationItem.parent.create(recursive: true);

    if (deletedItem is Directory) {
      await _copyDirectory(deletedItem.uri, (destinationItem as Directory).uri);
    } else {
      await (deletedItem as File).copy(destinationItem.path);
    }

    // Remove the item from .trash after restoring
    await deletedItem.delete(recursive: true);
  }

  static Future<void> permanentlyDeleteItem(String itemPath) async {
    final item =
        FileSystemEntity.typeSync(itemPath) == FileSystemEntityType.directory
            ? Directory(itemPath)
            : File(itemPath);

    if (await item.exists()) {
      await item.delete(recursive: true);
    }
  }

  // Get files (and folders) of a folder

  static Future<List<FileSystemEntity>> listFolderContents(Uri folderUri,
      {bool recursive = false, bool showHidden = false}) async {
    final folder = Directory.fromUri(folderUri);
    if (await folder.exists()) {
      final contents = await folder.list(recursive: recursive).toList();
      if (showHidden) {
        return contents;
      } else {
        // Filter out hidden folders and files
        final filteredContents = contents.where((item) {
          final pathSegments =
              path.split(item.path.replaceFirst(folderUri.toFilePath(), ''));
          return !pathSegments.any((segment) => segment.startsWith('.'));
        }).toList();
        return filteredContents;
      }
    }
    return [];
  }

  // For moving files and folders around
  static Future<void> moveItem(Uri itemUri, Uri newLocationUri) async {
    final String itemName = path.basename(itemUri.toFilePath());
    final String newPath = path.join(newLocationUri.toFilePath(), itemName);

    try {
      final item = await FileSystemEntity.isFile(itemUri.toFilePath())
          ? File.fromUri(itemUri)
          : Directory.fromUri(itemUri);
      await item.rename(newPath);
    } catch (e) {
      debugPrint('Error moving item: $e');
    }
  }

  static Future<void> moveManyItems(
      List<Uri> itemUris, Uri newLocationUri) async {
    for (Uri itemUri in itemUris) {
      final String itemName = path.basename(itemUri.toFilePath());
      final String newPath = path.join(newLocationUri.toFilePath(), itemName);
      try {
        final item = await FileSystemEntity.isFile(itemUri.toFilePath())
            ? File.fromUri(itemUri)
            : Directory.fromUri(itemUri);
        await item.rename(newPath);
      } catch (e) {
        debugPrint('Error moving item: $e');
      }
    }
  }

  // For renaming files and folders (replaced old renameNote() and renameFolder())
  static Future<bool> renameItem(Uri oldPathUri, String newName) async {
    try {
      final oldPath = oldPathUri.toFilePath();
      final isFile = await FileSystemEntity.isFile(oldPath);
      final item = isFile ? File(oldPath) : Directory(oldPath);

      // if (Platform.isAndroid) {
      //   if (DocumentFile(uri: oldPath.toString()).exists) {
      //     final parentDir = path.dirname(oldPath);
      //     final newPathUri = Uri.file(path.join(parentDir, newName));
      //     var e = await DocumentFile.fromUri(oldPath);
      //     // no rename feature so need to copy and delete
      //     e?.copyTo(newPathUri.toString());
      //     e?.delete();
      //     return true;
      //   }
      // }

      if (await item.exists()) {
        final parentDir = path.dirname(oldPath);
        final newPathUri = Uri.file(path.join(parentDir, newName));

        if (await nameExists(newName, parentPath: parentDir)) {
          throw Exception('A file or folder with this name already exists.');
        }

        await item.rename(newPathUri.toFilePath());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error renaming item: $e');
      return false;
    }
  }
}
