import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';

import 'package:printnotes/constants/sync_status_codes.dart';

class FTPSync {
  FTPSync({
    required this.serverUrl,
    required this.username,
    required this.password,
  });

  final String serverUrl;
  String username;
  final String password;

  Future<SyncStatusCode> syncNotes(String localPath) async {
    if (username.isEmpty) username = 'anonymous';

    final FTPConnect ftpClient =
        FTPConnect(serverUrl, user: username, pass: password);

    try {
      bool isConnected = await ftpClient.connect();
      if (isConnected) {
        ftpClient.listCommand = ListCommand.LIST;
        var allItems = await ftpClient.listDirectoryContent();
        for (var item in allItems) {
          debugPrint(
              'Item: ${item.name}, last modified: ${item.modifyTime.toString()}, type: ${item.type}');
        }

        await ftpClient.disconnect();
      }
    } catch (e) {
      debugPrint('Error syncing notes: $e');
      return SyncStatusCode.error;
    }
    return SyncStatusCode.success;
  }
}
