import 'dart:async';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/syncing/nextcloud/nextcloud_credentials.dart';
// import 'package:printnotes/utils/syncing/nextcloud/nextcloud_sync.dart';
import 'package:printnotes/utils/syncing/note_syncing.dart';
import 'package:printnotes/utils/syncing/sync_timeline.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class SyncServiceLogin extends StatefulWidget {
  const SyncServiceLogin({
    super.key,
    required this.directory,
    required this.service,
  });

  final String directory;
  final String service;

  @override
  State<SyncServiceLogin> createState() => _SyncServiceLoginState();
}

class _SyncServiceLoginState extends State<SyncServiceLogin> {
  Map<String, String?> credentials = {};
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSyncing = false;
  String lastSyncTime = 'Never';

  @override
  void initState() {
    super.initState();
    _loadSyncServiceData();
  }

  Widget _getServiceIcon() {
    String serviceIcon = '';
    if (widget.service == "Nextcloud") {
      serviceIcon = 'assets/icons/nextcloud-icon.png';
    }
    if (widget.service == "FTP") {
      serviceIcon = 'assets/icons/ftp-icon.png';
    }
    if (widget.service == "RSync") {
      serviceIcon = 'assets/icons/rsync-icon.png';
    }
    return serviceIcon.isNotEmpty
        ? Image.asset(
            serviceIcon,
            color: IconTheme.of(context).color,
            width: 30,
            height: 30,
          )
        : const Icon(Icons.cloud);
  }

  Future<void> _loadSyncServiceData() async {
    final syncTimeline = await LastSyncTime.getLastSyncTimeString();
    if (widget.service == "Nextcloud") {
      credentials = await NextcloudCredentials.getCredentials();
    }
    if (widget.service == "FTP") {
      credentials = {}; //TODO: Setup ftp credentials
    }
    setState(() {
      _serverUrlController.text = credentials['serverUrl'] ?? '';
      _usernameController.text = credentials['username'] ?? '';
      _passwordController.text = credentials['password'] ?? '';

      lastSyncTime = syncTimeline;
    });
  }

  Future<void> _deleteCredentials() async {
    if (widget.service == "Nextcloud") {
      await NextcloudCredentials.deleteCredentials();
    }
    _loadSyncServiceData();
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Cleared ${widget.service} credentials'));
    }
  }

  Future<void> _syncFirstTime() async {
    if (_formKey.currentState!.validate()) {
      if (widget.service == "Nextcloud") {
        await NextcloudCredentials.saveCredentials(
          serverUrl: _serverUrlController.text,
          username: _usernameController.text,
          password: _passwordController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }

      syncNextcloud();
    }
  }

  // TODO: Test if this actually still works
  void syncNextcloud() {
    NoteSyncing.syncNextcloudNotes(
      context,
      directory: widget.directory,
      isSyncing: () => setState(
        () => _isSyncing = !_isSyncing,
      ),
      urlControllerText: _serverUrlController.text,
      usernameControllerText: _usernameController.text,
      passwordControllerText: _passwordController.text,
    );
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
                        labelText: 'Server URL',
                        hintText: 'https://...',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        )),
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
          widget.service,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
        ),
        if (widget.service == "Nextcloud")
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
        //
        ListTile(
          leading: _getServiceIcon(),
          title: Text('Connect to ${widget.service} server'),
          onTap: _loginDialog,
        ),
        ListTile(
          leading: const Icon(Icons.timer),
          title: const Text('Last sync'),
          subtitle: Text(_isSyncing ? 'Syncing now...' : lastSyncTime),
          trailing: _isSyncing ? const CircularProgressIndicator() : null,
          onTap: _isSyncing ? null : syncNextcloud,
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
