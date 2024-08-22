import 'package:flutter/material.dart';

import 'package:printnotes/view/screens/archive_screen.dart';
import 'package:printnotes/view/screens/deleted_screen.dart';
import 'package:printnotes/view/screens/settings_screen.dart';
import 'package:printnotes/view/screens/sync_service_screen.dart';
import 'package:printnotes/view/screens/about_screen.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({
    super.key,
    required this.directory,
    required this.onItemChanged,
  });

  final String directory;
  final VoidCallback onItemChanged;

  void _navigateToScreen(BuildContext context, {Widget? screen}) {
    final bool isDrawerPersistent = MediaQuery.of(context).size.width >= 800;
    // On desktop, drawer is a side menu, trying to pop it causes issues
    // this stops it.
    if (!isDrawerPersistent) {
      Navigator.pop(context);
    }

    if (screen != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => screen,
          ))
          .then((_) => onItemChanged());
    } else {
      onItemChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.primary),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_document,
                  size: 48,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          leading: const Icon(Icons.article_outlined),
          title: const Text('All Notes'),
          onTap: () => _navigateToScreen(context),
        ),
        const Divider(),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          leading: const Icon(Icons.archive_outlined),
          title: const Text('Archive'),
          onTap: () =>
              _navigateToScreen(context, screen: const ArchiveScreen()),
        ),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          leading: const Icon(Icons.delete_outline),
          title: const Text('Deleted'),
          onTap: () =>
              _navigateToScreen(context, screen: const DeletedScreen()),
        ),
        const Divider(),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () => _navigateToScreen(context,
              screen: SettingsScreen(
                onSettingsChanged: onItemChanged,
              )),
        ),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          leading: const Icon(Icons.sync),
          title: const Text('Sync'),
          onTap: () => _navigateToScreen(
            context,
            screen: SyncServiceScreen(directory: directory),
          ),
        ),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          leading: const Icon(Icons.info_outlined),
          title: const Text('About'),
          onTap: () => _navigateToScreen(context, screen: const AboutScreen()),
        ),
      ],
    );
  }
}
