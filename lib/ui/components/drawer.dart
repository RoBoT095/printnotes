import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/utils/handlers/open_url_link.dart';

import 'package:printnotes/ui/screens/trash_archive_screens.dart';
import 'package:printnotes/ui/screens/settings/settings_screen.dart';
import 'package:printnotes/ui/screens/about/about_screen.dart';

import 'package:printnotes/constants/constants.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key, required this.reload});

  final VoidCallback reload;

  void _navigateToScreen(BuildContext context, {Widget? screen, String? path}) {
    Navigator.pop(context);

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
    return Column(
      children: [
        Expanded(
          child: ListTileTheme(
            iconColor: Theme.of(context).colorScheme.secondary,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // DrawerHeader without bottom border
                Container(
                  height: MediaQuery.paddingOf(context).top + 160.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary),
                  child: AnimatedContainer(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0)
                        .add(EdgeInsets.only(
                            top: MediaQuery.paddingOf(context).top)),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn,
                    child: Image.asset(
                      "assets/app_icon_no-bg.png",
                      height: 48,
                    ),
                  ),
                ),
                ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: const Text('All Notes'),
                    onTap: () {
                      _navigateToScreen(context,
                          path: context.read<SettingsProvider>().mainDir);
                      reload();
                    }),
                ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('Recent'),
                    onTap: () {
                      _navigateToScreen(context, path: '⏱');
                      reload();
                    }),
                ExpansionTile(
                  leading: Icon(Icons.tag),
                  title: Text('Tags'),
                  collapsedIconColor: Theme.of(context).colorScheme.secondary,
                  children: context.watch<SettingsProvider>().tagList.isNotEmpty
                      ? context
                          .watch<SettingsProvider>()
                          .tagList
                          .map(
                            (tag) => ListTile(
                                title: Text(tag),
                                onTap: () {
                                  _navigateToScreen(context, path: '※$tag');
                                  reload();
                                }),
                          )
                          .toList()
                      : [
                          ListTile(
                            title: Text('You don\'t have any tags'),
                          ),
                        ],
                  onExpansionChanged: (expanded) {
                    if (expanded) context.read<SettingsProvider>().getTagList();
                  },
                ),
                const Opacity(opacity: 0.2, child: Divider()),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text('Archive'),
                  onTap: () => _navigateToScreen(context,
                      path: context.read<SettingsProvider>().archivePath,
                      screen: const TrashArchiveScreen(
                        screenName: 'Archive',
                      )),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outlined),
                  title: const Text('Trash'),
                  onTap: () => _navigateToScreen(context,
                      path: context.read<SettingsProvider>().trashPath,
                      screen: const TrashArchiveScreen(
                        screenName: 'Trash',
                      )),
                ),
                const Opacity(opacity: 0.2, child: Divider()),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () => _navigateToScreen(context,
                      screen: const SettingsScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outlined),
                  title: const Text('About'),
                  onTap: () =>
                      _navigateToScreen(context, screen: const AboutScreen()),
                ),
                ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Wiki'),
                    trailing: const Icon(Icons.launch_rounded),
                    onTap: () => urlHandler(context,
                        'https://github.com/RoBoT095/printnotes/wiki')),
              ],
            ),
          ),
        ),
        ListTile(
          title: Opacity(
            opacity: 0.5,
            child: Text(
              'Version: $appVersion',
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
