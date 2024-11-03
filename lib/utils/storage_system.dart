import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/data_path.dart';

// The Abomination Folder that handles everything related to folders on the device
// better to rewrite and clean up everything but this sand castle is already held by hot glue
class StorageSystem {
  // For searching

  static Future<List<FileSystemEntity>> searchItems(
    String query,
    String currentDirectory,
  ) async {
    final results = <FileSystemEntity>[];

    Future<void> searchDirectory(Directory dir) async {
      try {
        await for (var entity in dir.list()) {
          final name = path.basename(entity.path).toLowerCase();
          final relativePath =
              path.relative(entity.path, from: currentDirectory);

          // Skip hidden folders and their contents
          if (relativePath
              .split(path.separator)
              .any((part) => part.startsWith('.'))) {
            continue;
          }
          // Find notes that match query, add to results
          if (name.contains(query.toLowerCase())) {
            if (entity is File) results.add(entity);
          }
          // If it is a folder, search inside it
          if (entity is Directory) {
            await searchDirectory(entity);
          }
        }
      } catch (e) {
        debugPrint('Error accessing directory: ${dir.path}');
      }
    }

    await searchDirectory(Directory(currentDirectory));
    return results;
  }

  // Methods for archiving

  static Future<String> getArchivePath() async {
    final basDir = await DataPath.selectedDirectory;
    return path.join(basDir!, '.archive');
  }

  static Future<void> unarchiveItem(String archivedItemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final archiveDir = await getArchivePath();
    final relativePath = path.relative(archivedItemPath, from: archiveDir);
    final destinationPath = path.join(baseDir!, relativePath);

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
      await _copyDirectory(archivedItem, destinationItem as Directory);
    } else {
      await (archivedItem as File).copy(destinationItem.path);
    }

    // Delete the archived item after unarchiving
    await archivedItem.delete(recursive: true);
  }

  static Future<void> archiveItem(String itemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final archiveDir = await getArchivePath();
    final relativePath = path.relative(itemPath, from: baseDir!);
    final archivePath = path.join(archiveDir, relativePath);

    final sourceItem =
        FileSystemEntity.typeSync(itemPath) == FileSystemEntityType.directory
            ? Directory(itemPath)
            : File(itemPath);

    final archiveItem =
        FileSystemEntity.typeSync(itemPath) == FileSystemEntityType.directory
            ? Directory(archivePath)
            : File(archivePath);

    await archiveItem.parent.create(recursive: true);

    if (sourceItem is Directory) {
      await _copyDirectory(sourceItem, archiveItem as Directory);
    } else {
      await (sourceItem as File).copy(archiveItem.path);
    }

    // Delete the original item after archiving
    await sourceItem.delete(recursive: true);
  }

  static Future<List<FileSystemEntity>> listArchivedItems(
      [String? folderPath]) async {
    final archiveDir = folderPath ?? await getArchivePath();
    final archiveDirEntity = Directory(archiveDir);

    if (await archiveDirEntity.exists()) {
      final entities = await archiveDirEntity.list().toList();
      return entities.where((entity) {
        return !path.basename(entity.path).startsWith('.');
      }).toList();
    }
    return [];
  }

  static Future<void> _copyDirectory(
      Directory source, Directory destination) async {
    await destination.create(recursive: true);

    await for (var entity in source.list(recursive: false)) {
      if (entity is Directory) {
        var newDirectory =
            Directory(path.join(destination.path, path.basename(entity.path)));
        await _copyDirectory(entity, newDirectory);
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

  // Methods related to creating, renaming, and moving notes

  static Future<File> createNote(String fileName, {String? parentPath}) async {
    final baseDir = parentPath ?? await DataPath.selectedDirectory;
    if (await nameExists(fileName, parentPath: baseDir)) {
      throw Exception('A note or folder with this name already exists.');
    }
    final filePath = path.join(baseDir!, '$fileName.md');
    return File(filePath).create(recursive: true);
  }

  static Future<bool> renameNote(String oldPath, String newName) async {
    try {
      final file = File(oldPath);
      if (await file.exists()) {
        final directory = path.dirname(oldPath);
        final newPath = path.join(directory, '$newName.md');

        if (await nameExists(newName, parentPath: directory)) {
          throw Exception('A note or folder with this name already exists.');
        }

        await file.rename(newPath);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error renaming note: $e');
      return false;
    }
  }

  static Future<String> loadNote(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }

  static Future<String> saveNote(fileName, String content,
      {String? parentPath}) async {
    final file = await createNote(fileName, parentPath: parentPath);
    await file.writeAsString(content);
    return file.path;
  }

  static Future<bool> moveNote(
      String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (await sourceFile.exists()) {
        await sourceFile.rename(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error moving note: $e');
      return false;
    }
  }

  static String getNotePreview(String filePath, {int previewLength = 100}) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        String content = file.readAsStringSync();
        // Limit to previewLength then trim whitespace
        return content
            .substring(0,
                content.length < previewLength ? content.length : previewLength)
            .trim();
      }
    } catch (e) {
      debugPrint('Error reading file: $e');
    }
    return 'No preview available';
  }

  // Method to duplicate Notes (only, not folders)
  // adds _copy to end of name, continues adding a num if a copy already exists
  static Future<String> duplicateNote(String originalPath) async {
    final directory = path.dirname(originalPath);
    final extension = path.extension(originalPath);
    final nameWithoutExtension = path.basenameWithoutExtension(originalPath);

    String newName = '${nameWithoutExtension}_copy';
    String newPath = path.join(directory, '$newName$extension');
    int copyNumber = 1;

    while (await File(newPath).exists()) {
      copyNumber++;
      newName = '${nameWithoutExtension}_copy';
      if (copyNumber > 1) {
        newName += '_$copyNumber';
      }
      newPath = path.join(directory, '$newName$extension');
    }

    final originalFile = File(originalPath);
    await originalFile.copy(newPath);

    return newPath;
  }

  // Methods related to creating and renaming folders

  static Future<String> createFolder(String folderName,
      {String? parentPath}) async {
    final baseDir = parentPath ?? await DataPath.selectedDirectory;
    if (await nameExists(folderName, parentPath: baseDir)) {
      throw Exception('A note or folder with this name already exists.');
    }
    final newFolder = Directory(path.join(baseDir!, folderName));
    if (!await newFolder.exists()) {
      await newFolder.create(recursive: true);
    }
    return newFolder.path;
  }

  static Future<bool> renameFolder(
      String oldFolderPath, String newFolderName) async {
    try {
      final folder = Directory(oldFolderPath);
      if (await folder.exists()) {
        final parentPath = folder.parent.path;
        final newFolderPath = path.join(parentPath, newFolderName);

        if (await nameExists(newFolderName, parentPath: parentPath)) {
          throw Exception('A note or folder with this name already exists.');
        }

        await folder.rename(newFolderPath);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error renaming folder: $e');
      return false;
    }
  }

  // Methods to soft and permanent delete

  static Future<String> getDeletedPath() async {
    final basDir = await DataPath.selectedDirectory;
    return path.join(basDir!, '.trash');
  }

  static Future<void> softDeleteItem(String itemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final deleteDir = await getDeletedPath();
    final relativePath = path.relative(itemPath, from: baseDir!);
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
      await _copyDirectory(sourceItem, deletedItem as Directory);
    } else {
      await (sourceItem as File).copy(deletedItem.path);
    }

    // Delete the original item after moving to .trash
    await sourceItem.delete(recursive: true);
  }

  static Future<void> restoreDeletedItem(String deletedItemPath) async {
    final baseDir = await DataPath.selectedDirectory;
    final deleteDir = await getDeletedPath();
    final itemName = path.basename(deletedItemPath);
    final relativePath =
        path.relative(path.dirname(deletedItemPath), from: deleteDir);
    final destinationPath = path.join(baseDir!, relativePath, itemName);

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
      await _copyDirectory(deletedItem, destinationItem as Directory);
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

  static List<FileSystemEntity> listFolderContents(
    String folderPath,
  ) {
    final folder = Directory(folderPath);
    if (folder.existsSync()) {
      final contents = folder.listSync().toList();
      // Skips hidden folders
      final filteredContents = contents.where((item) {
        return !item.path.split(Platform.pathSeparator).last.startsWith('.');
      }).toList();
      return filteredContents;
    }
    return [];
  }

  // For moving files and folders around
  static Future<void> moveItem(
      FileSystemEntity item, String newLocation) async {
    final String itemName = path.basename(item.path);
    final String newPath = path.join(newLocation, itemName);

    try {
      await item.rename(newPath);
    } catch (e) {
      debugPrint('Error moving item: $e');
    }
  }
}
