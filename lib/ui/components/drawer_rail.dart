import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/ui/screens/archive/archive_screen.dart';
import 'package:printnotes/ui/screens/trash/trash_screen.dart';
import 'package:printnotes/ui/screens/settings/settings_screen.dart';
import 'package:printnotes/ui/screens/about/about_screen.dart';

class DrawerRailView extends StatelessWidget {
  const DrawerRailView({super.key});

  void _navigateToScreen(BuildContext context, {Widget? screen, String? path}) {
    if (path != null) {
      context.read<NavigationProvider>().addToRouteHistory(path);
    }
    if (screen != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => screen,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary))),
      child: Container(
        alignment: Alignment.center,
        color: Theme.of(context).colorScheme.primary,
        child: ListView(
          children: [
            IconButton(
                icon: const Icon(Icons.article_outlined),
                tooltip: 'All Notes',
                onPressed: () {
                  _navigateToScreen(context,
                      path: context.read<SettingsProvider>().mainDir);
                }),
            const Opacity(opacity: 0.2, child: Divider()),
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              tooltip: 'Archive',
              onPressed: () => _navigateToScreen(context,
                  path: context.read<SettingsProvider>().archivePath,
                  screen: const ArchiveScreen()),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              tooltip: 'Trash',
              onPressed: () => _navigateToScreen(context,
                  path: context.read<SettingsProvider>().trashPath,
                  screen: const DeletedScreen()),
            ),
            const Opacity(opacity: 0.2, child: Divider()),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () =>
                  _navigateToScreen(context, screen: const SettingsScreen()),
            ),
            IconButton(
              icon: const Icon(Icons.info_outlined),
              tooltip: 'About',
              onPressed: () =>
                  _navigateToScreen(context, screen: const AboutScreen()),
            ),
            IconButton(
                icon: const Icon(Icons.help_outline),
                tooltip: 'Wiki',
                onPressed: () => launchUrl(
                    Uri.parse('https://github.com/RoBoT095/printnotes/wiki'))),
          ],
        ),
      ),
    );
  }
}
