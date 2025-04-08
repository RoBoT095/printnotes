import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/ui/widgets/custom_snackbar.dart';
import 'package:printnotes/ui/components/dialogs/libraries_dialog.dart';
import 'package:printnotes/constants/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _urlHandler(BuildContext context, dynamic url,
      {bool copyToClipboard = false}) async {
    if (copyToClipboard) {
      await Clipboard.setData(ClipboardData(text: url)).then((_) {
        if (context.mounted) {
          customSnackBar('Copied to clipboard!', type: 'success').show(context);
        }
      });
    } else {
      url = Uri.parse(url);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isScreenLarge = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text('About'),
      ),
      body: Container(
        margin: isScreenLarge
            ? EdgeInsets.symmetric(horizontal: (screenWidth - 600) / 2)
            : null,
        child: ListView(
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
              onTap: () => _urlHandler(
                  context, 'https://github.com/RoBoT095/printnotes'),
              onLongPress: () => _urlHandler(
                  context, 'https://github.com/RoBoT095/printnotes',
                  copyToClipboard: true),
              trailing: const Icon(Icons.launch_rounded),
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.person),
              title: const Text('Developer'),
              subtitle: const Text('RoBoT_095 aka Rob'),
              onTap: () => _urlHandler(context, 'https://github.com/RoBoT095'),
              onLongPress: () => _urlHandler(
                  context, 'https://github.com/RoBoT095',
                  copyToClipboard: true),
              trailing: const Icon(Icons.launch_rounded),
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.favorite_border_rounded),
              title: const Text('Support'),
              subtitle: const Text(
                  "I'm a solo dev working hard on this, \nMaybe buy me some Coffee?"),
              onTap: () =>
                  _urlHandler(context, 'https://buymeacoffee.com/robot_095'),
              onLongPress: () => _urlHandler(
                  context, 'https://buymeacoffee.com/robot_095',
                  copyToClipboard: true),
              trailing: const Icon(Icons.launch_rounded),
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.menu_book),
              title: const Text('Libraries'),
              subtitle: const Text(
                  'Click to view third-party libraries and licenses.'),
              onTap: () => showLibrariesDialog(context),
              trailing: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.article),
              title: const Text('App License'),
              subtitle:
                  const Text("This App is protected under the GPL 3 License"),
              onTap: () => _urlHandler(
                  context, 'https://www.gnu.org/licenses/gpl-3.0.en.html'),
              onLongPress: () => _urlHandler(
                  context, 'https://www.gnu.org/licenses/gpl-3.0.en.html',
                  copyToClipboard: true),
              trailing: const Icon(Icons.launch_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
