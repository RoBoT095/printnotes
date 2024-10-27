import 'package:flutter/material.dart';

import 'package:printnotes/utils/syncing/server_credentials.dart';
import 'package:printnotes/utils/syncing/nextcloud/nextcloud_sync.dart';
import 'package:printnotes/utils/syncing/sync_timeline.dart';
import 'package:printnotes/constants/sync_status_codes.dart';

Future<void> runNotesSync(
  BuildContext context, {
  required String directory,
  required VoidCallback isSyncing,
  required ValueSetter lastSyncTime,
  required String syncService,
  required String urlControllerText,
  required String usernameControllerText,
  required String passwordControllerText,
  required ValueSetter<String> syncResponse,
}) async {
  var credentials = await ServerCredentials.getCredentials();
  SyncStatusCode response = SyncStatusCode.success;

  isSyncing();

  if (syncService == "Nextcloud") {
    final nextcloudSync = NextcloudSync(
      serverUrl: credentials['serverUrl'] ?? urlControllerText,
      username: credentials['username'] ?? usernameControllerText,
      password: credentials['password'] ?? passwordControllerText,
    );

    response = await nextcloudSync.syncNotes(directory);
    syncResponse(response.name);
  }
  if (syncService == "FTP") {
    // TODO
  }
  if (syncService == "RSync") {
    // TODO
  }

  isSyncing();

  if (response == SyncStatusCode.success) {
    LastSyncTime.setLastSyncTime();
    String newSyncTime = await LastSyncTime.getLastSyncTimeString();
    lastSyncTime(newSyncTime);

    syncResponse(response.name);
  }
}
