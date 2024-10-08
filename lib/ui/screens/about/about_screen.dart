import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/ui/components/dialogs/libraries_dialog.dart';
import 'package:printnotes/constants/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(url) async {
    url = Uri.parse(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text(appVersion),
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.code),
            title: const Text('Contribute'),
            subtitle: const Text('https://github.com/RoBoT095/printnotes'),
            onTap: () => _launchUrl('https://github.com/RoBoT095/printnotes'),
            trailing: const Icon(Icons.launch_rounded),
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.person),
            title: const Text('Developer'),
            subtitle: const Text('RoBoT_095 aka Rob'),
            onTap: () => _launchUrl('https://github.com/RoBoT095'),
            trailing: const Icon(Icons.launch_rounded),
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.favorite_border_rounded),
            title: const Text('Support'),
            subtitle: const Text(
                "I'm a solo dev working hard on this, \nMaybe buy me some Coffee?"),
            onTap: () => _launchUrl('https://liberapay.com/RoBoT_095/donate'),
            trailing: const Icon(Icons.launch_rounded),
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.menu_book),
            title: const Text('Libraries'),
            subtitle:
                const Text('Click to view third-party libraries and licenses.'),
            onTap: () => showLibrariesDialog(context),
            trailing: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          ListTile(
            iconColor: Theme.of(context).colorScheme.secondary,
            leading: const Icon(Icons.article),
            title: const Text('App License'),
            subtitle:
                const Text("This App is protected under the GPL 3 License"),
            onTap: () =>
                _launchUrl('https://www.gnu.org/licenses/gpl-3.0.en.html'),
            trailing: const Icon(Icons.launch_rounded),
          ),
        ],
      ),
    );
  }
}
