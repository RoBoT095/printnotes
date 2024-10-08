import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/view/components/widgets/list_section_title.dart';

class CustomThemePage extends StatelessWidget {
  const CustomThemePage({super.key});

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
        title: const Text('Custom Themes'),
      ),
      body: ListView(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: 'Make and import your theme from ',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            TextSpan(
                // TODO: Change title text
                text: 'www.example.com',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  // TODO: Change Url
                  ..onTap = () => _launchUrl(
                      'https://github.com/RoBoT095/printnotes_theme_maker'))
          ])),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Import theme string here...',
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6)),
                ),
                enableSuggestions: false,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary),
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {},
            child: const Text('Import'),
          ),
          const Divider(),
          // List of light themes, ones with Brightness.light
          sectionTitle(
            'Light Theme',
            Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 200),
          const Divider(),
          // List of dark themes, ones with Brightness.dark
          sectionTitle(
            'Dark Theme',
            Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
