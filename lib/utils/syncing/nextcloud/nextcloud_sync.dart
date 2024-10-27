import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/webdav.dart';

import 'package:printnotes/constants/sync_status_codes.dart';

class NextcloudSync {
  NextcloudSync(
      {required this.serverUrl,
      required this.username,
      required this.password});

  final String serverUrl;
  final String username;
  final String password;

  Future<SyncStatusCode> syncNotes(
    String localPath,
  ) async {
    final client = NextcloudClient(Uri.parse(serverUrl),
        loginName: username, password: password);

    SyncStatusCode status = SyncStatusCode.success;

    try {
      final remotePath = PathUri.parse(path.basename(localPath));
      bool folderExists = await checkRemoteItemExists(remotePath, client);
      if (!folderExists) {
        client.webdav.mkcol(remotePath);
      }
      final uploadStatus =
          await createRemoteDirectoryStructure(localPath, remotePath, client);

      if (uploadStatus != status) {
        status = uploadStatus;
      }
    } catch (e) {
      debugPrint('Error syncing notes: $e');
      return status = SyncStatusCode.error;
    }
    return status;
  }

  Future<bool> checkRemoteItemExists(
      PathUri path, NextcloudClient client) async {
    try {
      await client.webdav.propfind(path);
      return true;
    } on DynamiteStatusCodeException catch (e) {
      if (e.statusCode == 404) {
        // Means item doesn't exist and should be created
        return false;
      }
      debugPrint(
          'Item existence check status code: ${e.statusCode} on path $path');
      return false;
    }
  }

  Future<SyncStatusCode> createRemoteDirectoryStructure(
    String localPath,
    PathUri remotePath,
    NextcloudClient client,
  ) async {
    final directory = Directory(localPath);
    final entities = await directory.list().toList();

    SyncStatusCode overallStatus = SyncStatusCode.success;

    for (final entity in entities) {
      final relativePath = path.relative(entity.path, from: directory.path);
      final pathSegments = relativePath.split(Platform.pathSeparator);
      if (pathSegments.any((segment) => segment.startsWith('.'))) continue;

      String remotePathString = remotePath.toString();
      for (final segment in pathSegments) {
        remotePathString = path.join(remotePathString, segment);
        final remotePathUri = PathUri.parse(remotePathString);

        if (entity is File) {
          final uploadStatus = await _uploadFile(entity, remotePathUri, client);

          overallStatus = overallStatus == SyncStatusCode.success
              ? uploadStatus
              : overallStatus;
          await Future.delayed(const Duration(microseconds: 100));
        }
        if (entity is Directory) {
          final createStatus = await _uploadFolder(entity, remotePath, client);
          overallStatus = overallStatus == SyncStatusCode.success
              ? createStatus
              : overallStatus;

          await Future.delayed(const Duration(milliseconds: 100));

          final subDirStatus = await createRemoteDirectoryStructure(
            entity.path,
            remotePathUri,
            client,
          );
          overallStatus = overallStatus == SyncStatusCode.success
              ? subDirStatus
              : overallStatus;
        }
      }
    }
    return overallStatus;
  }

  Future<SyncStatusCode> _uploadFile(
    File file,
    PathUri remotePath,
    NextcloudClient client,
  ) async {
    bool exists = await checkRemoteItemExists(
        PathUri.parse(path.basename(file.path)), client);
    final fileStat = FileStat.statSync(file.path);
    if (exists == false) {
      try {
        await client.webdav.putFile(file, fileStat, remotePath);
        return SyncStatusCode.success;
      } on DynamiteStatusCodeException catch (e) {
        debugPrint('Failed to upload File: ${e.statusCode}, with Uri ${e.uri}');

        return SyncStatusCode.fileUploadFailedError;
      }
    }
    return SyncStatusCode.success;
  }

  Future<SyncStatusCode> _uploadFolder(
    Directory folder,
    PathUri remotePath,
    NextcloudClient client,
  ) async {
    bool exists = await checkRemoteItemExists(
        PathUri.parse('${remotePath.name}/${path.basename(folder.path)}'),
        client);
    if (exists == false) {
      try {
        await client.webdav
            .mkcol(PathUri.parse('$remotePath/${path.basename(folder.path)}'));
        return SyncStatusCode.success;
      } on DynamiteStatusCodeException catch (e) {
        if (e.statusCode == 405) {
          // Status Code 405: Method Not Allowed
          // Usually it means it worked, I am just too lazy to fix check for the
          // nested folders
          return SyncStatusCode.success;
        }
        debugPrint(
            'Failed to create Folder: ${e.statusCode}, with Uri ${e.uri}');
        return SyncStatusCode.folderCreationFailedError;
      }
    }
    return SyncStatusCode.success;
  }
}
