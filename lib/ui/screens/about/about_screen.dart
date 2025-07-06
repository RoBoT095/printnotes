import 'package:flutter/material.dart';

import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/dialogs/libraries_dialog.dart';
import 'package:printnotes/utils/handlers/open_url_link.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isScreenLarge = screenWidth >= 800;

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
        child: Container(
          margin: isScreenLarge
              ? EdgeInsets.symmetric(horizontal: (screenWidth - 800) / 2)
              : null,
          child: Column(
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
                onTap: () => urlHandler(
                    context, 'https://github.com/RoBoT095/printnotes'),
                onLongPress: () => urlHandler(
                    context, 'https://github.com/RoBoT095/printnotes',
                    copyToClipboard: true),
                trailing: const Icon(Icons.launch_rounded),
              ),
              ListTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.person),
                title: const Text('Developer'),
                subtitle: const Text('RoBoT_095 aka Rob'),
                onTap: () => urlHandler(context, 'https://github.com/RoBoT095'),
                onLongPress: () => urlHandler(
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
                    urlHandler(context, 'https://buymeacoffee.com/robot_095'),
                onLongPress: () => urlHandler(
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
                onTap: () => urlHandler(
                    context, 'https://www.gnu.org/licenses/gpl-3.0.en.html'),
                onLongPress: () => urlHandler(
                    context, 'https://www.gnu.org/licenses/gpl-3.0.en.html',
                    copyToClipboard: true),
                trailing: const Icon(Icons.launch_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
