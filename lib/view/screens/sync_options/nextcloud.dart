import 'dart:async';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/syncing/nextcloud/nextcloud_credentials.dart';
import 'package:printnotes/utils/syncing/nextcloud/nextcloud_sync.dart';
import 'package:printnotes/utils/syncing/sync_timeline.dart';
import 'package:printnotes/view/components/widgets/custom_snackbar.dart';

class NextcloudLogin extends StatefulWidget {
  const NextcloudLogin({
    super.key,
    required this.directory,
  });

  final String directory;

  @override
  State<NextcloudLogin> createState() => _NextcloudLoginState();
}

class _NextcloudLoginState extends State<NextcloudLogin> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSyncing = false;
  String lastSyncTime = 'Never';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentialsAndSyncTimeline();
  }

  Future<void> _loadSavedCredentialsAndSyncTimeline() async {
    final credentials = await NextcloudCredentials.getCredentials();
    final syncTimeline = await LastSyncTime.getLastSyncTimeString();
    setState(() {
      _serverUrlController.text = credentials['serverUrl'] ?? '';
      _usernameController.text = credentials['username'] ?? '';
      _passwordController.text = credentials['password'] ?? '';

      lastSyncTime = syncTimeline;
    });
  }

  Future<void> _deleteCredentials() async {
    await NextcloudCredentials.deleteCredentials();
    _loadSavedCredentialsAndSyncTimeline();
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar('Cleared Nextcloud credentials'));
    }
  }

  Future<void> _syncFirstTime() async {
    if (_formKey.currentState!.validate()) {
      await NextcloudCredentials.saveCredentials(
        serverUrl: _serverUrlController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }

      await _syncNotes();
    }
  }

  Future<void> _syncNotes() async {
    final credentials = await NextcloudCredentials.getCredentials();

    setState(() {
      _isSyncing = true;
    });

    final nextcloudSync = NextcloudSync(
      serverUrl: credentials['serverUrl'] ?? _serverUrlController.text,
      username: credentials['username'] ?? _usernameController.text,
      password: credentials['password'] ?? _passwordController.text,
    );

    final response = await nextcloudSync.syncNotes(widget.directory);
    debugPrint(response.name);

    LastSyncTime.setLastSyncTime();
    String newSyncTime = await LastSyncTime.getLastSyncTimeString();
    setState(() {
      _isSyncing = false;
      lastSyncTime = newSyncTime;
    });

    if (_isSyncing == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            response == SyncStatusCode.success
                ? 'Sync completed successfully'
                : 'Sync failed with ${response.name}'));
      }
    }
  }

  void _loginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sign in'),
                  TextFormField(
                    controller: _serverUrlController,
                    decoration: const InputDecoration(
                        labelText: 'Nextcloud Server URL'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter server URL' : null,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your username' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('close'),
            ),
            ElevatedButton(
              onPressed: _isSyncing ? null : _syncFirstTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              child: const Text('Sync Notes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Nextcloud',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
        ),
        Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                Icons.dangerous_outlined,
                size: 40,
              ),
              subtitle: Text(
                "Currently only uploads manually, doesn't pull and compare changes just yet.\nSorry for the inconvenience 😓",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/nextcloud-icon.png',
            color: IconTheme.of(context).color,
            width: 30,
            height: 30,
          ),
          title: const Text('Connect to Nextcloud server'),
          onTap: _loginDialog,
        ),
        ListTile(
          leading: const Icon(Icons.timer),
          title: const Text('Last sync'),
          subtitle: Text(_isSyncing ? 'Syncing now...' : lastSyncTime),
          trailing: _isSyncing ? const CircularProgressIndicator() : null,
          onTap: _isSyncing ? null : _syncNotes,
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Clear credentials'),
          onTap: _deleteCredentials,
        )
      ],
    );
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
