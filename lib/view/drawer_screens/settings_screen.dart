import 'package:flutter/material.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/themes/theme_provider.dart';
import 'package:printnotes/utils/configs/user_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onSettingsChanged,
  });

  final VoidCallback onSettingsChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _currentDirectory;
  String? _currentLayout;
  String? _currentTheme;
  String? _currentColorScheme;
  int? _currentDeletedDuration = 7;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsLoader.loadSettings();
    setState(() {
      _currentDirectory = settings['directory'];
      _currentLayout = settings['layout'];
      _currentTheme = settings['theme'];
      _currentColorScheme = settings['colorScheme'];
      _currentDeletedDuration = settings['deletedDuration'];
    });
  }

  Future<void> _pickDirectory() async {
    final pickedDirectory = await SettingsLoader.pickDirectory();
    if (pickedDirectory != null) {
      setState(() {
        _currentDirectory = pickedDirectory;
      });
      widget.onSettingsChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            title: const Text('Notes Storage Location'),
            subtitle: Text(_currentDirectory ?? 'Not set'),
            trailing: const Icon(Icons.folder),
            onTap: _pickDirectory,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.onSecondary),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.secondary)),
              onPressed: _pickDirectory,
              child: const Text('Change Folder'),
            ),
          ),
          const Divider(),
          sectionTitle(
            'View',
            10,
            Theme.of(context).colorScheme.primary,
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.view_module),
            title: const Text('Layout Mode'),
            trailing: DropdownButton(
                value: _currentLayout ?? 'grid',
                items: const [
                  DropdownMenuItem(
                    value: 'grid',
                    child: Text('Grid View'),
                  ),
                  DropdownMenuItem(
                    value: 'list',
                    child: Text('List View'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _currentLayout = value;
                    if (value != null) {
                      UserLayoutPref.setLayoutView(value);
                      widget.onSettingsChanged();
                    }
                  });
                }),
          ),
          const Divider(),
          sectionTitle(
            'Style',
            10,
            Theme.of(context).colorScheme.primary,
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(
              Icons.dark_mode_outlined,
            ),
            title: const Text('Theme Mode'),
            trailing: DropdownButton(
              value: _currentTheme ?? 'system',
              items: const [
                DropdownMenuItem(
                  value: 'system',
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: 'light',
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text('Dark'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _currentTheme = value;
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setThemeMode(value ?? 'system');
                  widget.onSettingsChanged();
                });
              },
            ),
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Color Scheme'),
            trailing: DropdownButton(
              value: _currentColorScheme,
              items: const [
                DropdownMenuItem(value: 'default', child: Text('Default')),
                DropdownMenuItem(
                    value: 'green_apple', child: Text('Green Apple')),
                DropdownMenuItem(value: 'lavender', child: Text('Lavender')),
                DropdownMenuItem(
                    value: 'strawberry', child: Text('Strawberry')),
              ],
              onChanged: (value) {
                setState(() {
                  _currentColorScheme = value;
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setColorScheme(value ?? 'default');
                  widget.onSettingsChanged();
                });
              },
            ),
          ),
          const Divider(),
          sectionTitle(
            'Other',
            10,
            Theme.of(context).colorScheme.primary,
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear Bin duration'),
            subtitle: const Opacity(
                opacity: 0.6,
                child: Text('Set when deleted notes get cleared')),
            trailing: DropdownButton(
              value: _currentDeletedDuration,
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 Day')),
                DropdownMenuItem(value: 7, child: Text('7 Days')),
                DropdownMenuItem(value: 14, child: Text('2 Weeks')),
                DropdownMenuItem(value: 30, child: Text('30 Days')),
              ],
              onChanged: (value) {
                setState(() {
                  _currentDeletedDuration = value;
                  StorageSystem.setDeletionDuration(value ?? 7);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, double padding, Color color) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: color),
      ),
    );
  }
}
