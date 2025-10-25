import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/centered_page_wrapper.dart';
import 'package:printnotes/ui/components/dialogs/libraries_dialog.dart';

import 'package:printnotes/ui/widgets/menu_tile.dart';

import 'package:printnotes/utils/handlers/open_url_link.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = '0.0.0';

  @override
  void initState() {
    _getPackageInfo();
    super.initState();
  }

  void _getPackageInfo() async {
    final package = await PackageInfo.fromPlatform();
    setState(() => appVersion = package.version);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          title: const Text('About'),
        ),
      ),
      body: SingleChildScrollView(
        child: CenteredPageWrapper(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              MenuTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.info_outline),
                title: 'Version',
                subtitle: MenuTile.subtitleText(context, text: appVersion),
                isFirst: true,
                isLast: true,
              ),
              const SizedBox(height: 12),
              MenuTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.code),
                title: 'Contribute',
                subtitle: MenuTile.subtitleText(context,
                    text: 'https://github.com/RoBoT095/printnotes'),
                onTap: () => urlHandler(
                    context, 'https://github.com/RoBoT095/printnotes'),
                onLongPress: () => urlHandler(
                    context, 'https://github.com/RoBoT095/printnotes',
                    copyToClipboard: true),
                trailing: const Icon(Icons.launch_rounded),
                isFirst: true,
              ),
              MenuTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.person),
                title: 'Developer',
                subtitle:
                    MenuTile.subtitleText(context, text: 'RoBoT_095 aka Rob'),
                onTap: () => urlHandler(context, 'https://github.com/RoBoT095'),
                onLongPress: () => urlHandler(
                    context, 'https://github.com/RoBoT095',
                    copyToClipboard: true),
                trailing: const Icon(Icons.launch_rounded),
              ),
              MenuTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.favorite_border_rounded),
                title: 'Support',
                subtitle: MenuTile.subtitleText(
                  context,
                  text:
                      "I'm a solo dev working hard on this, \nMaybe buy me some Coffee?",
                ),
                onTap: () =>
                    urlHandler(context, 'https://buymeacoffee.com/robot_095'),
                onLongPress: () => urlHandler(
                    context, 'https://buymeacoffee.com/robot_095',
                    copyToClipboard: true),
                trailing: const Icon(Icons.launch_rounded),
              ),
              MenuTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.menu_book),
                title: 'Libraries',
                subtitle: MenuTile.subtitleText(context,
                    text: 'Click to view third-party libraries and licenses.'),
                onTap: () => showLibrariesDialog(context),
                trailing: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              MenuTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.article),
                title: 'App License',
                subtitle: MenuTile.subtitleText(context,
                    text: "This App is protected under the GPL 3 License"),
                onTap: () => urlHandler(
                    context, 'https://www.gnu.org/licenses/gpl-3.0.en.html'),
                onLongPress: () => urlHandler(
                    context, 'https://www.gnu.org/licenses/gpl-3.0.en.html',
                    copyToClipboard: true),
                trailing: const Icon(Icons.launch_rounded),
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
