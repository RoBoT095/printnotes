import 'package:flutter/material.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

import 'package:printnotes/utils/syncing/nextcloud/nextcloud_credentials.dart';
import 'package:printnotes/utils/syncing/nextcloud/nextcloud_sync.dart';
import 'package:printnotes/utils/syncing/sync_timeline.dart';

class NoteSyncing {
  static Future<String> syncNextcloudNotes(
    BuildContext context, {
    required String directory,
    required VoidCallback isSyncing,
    required String urlControllerText,
    required String usernameControllerText,
    required String passwordControllerText,
  }) async {
    var credentials = await NextcloudCredentials.getCredentials();

    isSyncing();

    final nextcloudSync = NextcloudSync(
      serverUrl: credentials['serverUrl'] ?? urlControllerText,
      username: credentials['username'] ?? usernameControllerText,
      password: credentials['password'] ?? passwordControllerText,
    );

    final response = await nextcloudSync.syncNotes(directory);
    debugPrint(response.name);

    LastSyncTime.setLastSyncTime();
    String newSyncTime = await LastSyncTime.getLastSyncTimeString();
    isSyncing();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
        response == SyncStatusCode.success
            ? 'Sync completed successfully'
            : 'Sync failed with ${response.name}'));

    return newSyncTime;
  }
}
