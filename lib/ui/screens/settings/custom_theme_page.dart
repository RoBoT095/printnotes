import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/ui/widgets/custom_snackbar.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

class CustomThemePage extends StatefulWidget {
  const CustomThemePage({super.key});

  @override
  State<CustomThemePage> createState() => _CustomThemePageState();
}

class _CustomThemePageState extends State<CustomThemePage> {
  final _formKey = GlobalKey<FormState>();
  bool isCustomLightSelected = false;
  bool isCustomDarkSelected = false;

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
          Center(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Make and import your theme from ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  // TODO: Change title text
                  text: 'www.example.com',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    // TODO: Change Url
                    ..onTap = () => _launchUrl(
                        'https://github.com/RoBoT095/printnotes_theme_maker'))
            ])),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      hintText: 'Name your new theme...',
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6)),
                    ),
                    enableSuggestions: false,
                    validator: (name) {
                      //TODO: Check if name isn't already used
                      if (name == null || name.isEmpty) {
                        return 'Please enter a name for theme';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      hintText: 'Import theme string here...',
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6)),
                    ),
                    enableSuggestions: false,
                    validator: (theme) {
                      //TODO: Check if theme is parsable
                      if (theme == null || theme.isEmpty) {
                        return 'Please input valid theme';
                      }
                      return null;
                    },
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary),
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar('Saved Successfully'));
                        }
                      },
                      child: const Text('Import'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),
          // List of light themes, ones with Brightness.light
          sectionTitle(
            'Light Theme',
            Theme.of(context).colorScheme.primary,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: 30,
                    height: 30,
                  ),
                  title: Text('Custom Theme ${index + 1}'),
                  trailing: index.isEven ? const Icon(Icons.check) : null,
                );
              },
            ),
          ),
          const Divider(),
          // List of dark themes, ones with Brightness.dark
          sectionTitle(
            'Dark Theme',
            Theme.of(context).colorScheme.primary,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return ListTile();
              },
            ),
          )
        ],
      ),
    );
  }
}
