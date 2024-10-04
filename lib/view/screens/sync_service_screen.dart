import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/user_sync.dart';

import 'package:printnotes/utils/load_settings.dart';

import 'package:printnotes/view/components/popups/popup_list_dialog.dart';
import 'package:printnotes/view/screens/sync_options/nextcloud.dart';

class SyncServiceScreen extends StatefulWidget {
  const SyncServiceScreen({super.key, required this.directory});

  final String directory;

  @override
  State<SyncServiceScreen> createState() => _SyncServiceScreenState();
}

class _SyncServiceScreenState extends State<SyncServiceScreen> {
  String _selectedService = 'Disabled';
  // String _connectionType = 'WiFi';
  bool showMoreOptions = false;

  @override
  void initState() {
    super.initState();
    _loadSyncSettings();
  }

  Future<void> _loadSyncSettings() async {
    final syncSettings = await SettingsLoader.loadSyncSettings();
    setState(() {
      _selectedService = syncSettings['service'];
      // _connectionType = syncSettings['connection'];
      if (_selectedService != 'Disabled') {
        showMoreOptions = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Upload Notes'),
      ),
      body: ListView(
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.info_outline),
                subtitle: Text(
                  'Syncing is currently very experimental.\nIt is in development so you will encounter bugs.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.cloud_sync_outlined,
              size: iconSize,
            ),
            title: const Text('Syncing service'),
            subtitle: Text(_selectedService),
            onTap: () => showRadioListDialog(
              context,
              tileTitle: const Text('Select Sync Service'),
              selectedItem: _selectedService,
              items: [
                'Disabled',
                'Nextcloud',
                // 'RSync',
                // 'FTP',
                // 'Google Drive',
                // 'Dropbox'
              ],
              onUpdated: (value) async {
                setState(() {
                  _selectedService = value;
                  UserSyncPref.setSyncService(value);
                  if (value != 'Disabled') {
                    showMoreOptions = true;
                  } else {
                    showMoreOptions = false;
                  }
                });
              },
            ),
          ),
          // if (showMoreOptions)
          //   ListTile(
          //     leading: const Icon(Icons.sensors),
          //     title: const Text('Sync when on'),
          //     subtitle: Text(_connectionType),
          //     onTap: () => showRadioListDialog(
          //       context,
          //       tileTitle: const Text('Sync when on'),
          //       selectedItem: _connectionType,
          //       items: ['WiFi', 'WiFi & Data'],
          //       onUpdated: (value) {
          //         setState(() {
          //           _connectionType = value;
          //           UserSyncPref.setConnectionType(value);
          //         });
          //       },
          //     ),
          //   ),
          Divider(
            thickness: 2,
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          if (_selectedService == 'Nextcloud')
            NextcloudLogin(
              directory: widget.directory,
            )
        ],
      ),
    );
  }
}
