import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/ui/screens/settings/custom_theme_page.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String sliderLabels(int value) {
    String valString = value.toString();
    if (value == 0) {
      return 'Title Only: $valString';
    }
    if (value == 100) {
      return 'Default: $valString';
    }
    return valString;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isScreenLarge = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Settings'),
      ),
      body: Container(
        margin: isScreenLarge
            ? EdgeInsets.symmetric(
                horizontal: (MediaQuery.sizeOf(context).width - 600) / 2)
            : null,
        child: ListView(
          children: [
            if (!Platform.isIOS)
              ListTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                title: const Text('Notes Storage Location'),
                subtitle: Text(context.watch<SettingsProvider>().mainDir),
                trailing: const Icon(Icons.folder),
                onTap: () async {
                  final pickedDirectory = await DataPath.pickDirectory();
                  if (pickedDirectory != null && context.mounted) {
                    context
                        .read<SettingsProvider>()
                        .setMainDir(pickedDirectory);
                  }
                },
              ),
            if (!Platform.isIOS)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        fixedSize: const Size(250, 40)),
                    onPressed: () async {
                      final pickedDirectory = await DataPath.pickDirectory();
                      if (pickedDirectory != null && context.mounted) {
                        context
                            .read<SettingsProvider>()
                            .setMainDir(pickedDirectory);
                      }
                    },
                    child: const Text('Change Folder'),
                  ),
                ),
              ),
            if (!Platform.isIOS) const Divider(),
            sectionTitle(
              'View',
              Theme.of(context).colorScheme.secondary,
              padding: 10,
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.view_module),
              title: const Text('Layout Mode'),
              trailing: DropdownButton(
                  value: context.watch<SettingsProvider>().layout,
                  items: const [
                    DropdownMenuItem(value: 'grid', child: Text('Grid View')),
                    DropdownMenuItem(value: 'list', child: Text('List View')),
                    DropdownMenuItem(value: 'tree', child: Text('Tree View')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsProvider>().setLayout(value);
                    }
                  }),
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Note Preview amount'),
              subtitle: Slider(
                value:
                    context.watch<SettingsProvider>().previewLength.toDouble(),
                min: 0,
                max: 200,
                divisions: 10,
                label: sliderLabels(
                    context.watch<SettingsProvider>().previewLength),
                onChanged: (value) {
                  context
                      .read<SettingsProvider>()
                      .setPreviewLength(value.toInt());
                },
              ),
            ),
            const Divider(),
            sectionTitle(
              'Style',
              Theme.of(context).colorScheme.secondary,
              padding: 10,
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(
                Icons.light_mode_outlined,
              ),
              title: const Text('Theme Mode'),
              trailing: DropdownButton(
                value: context.watch<ThemeProvider>().themeModeString,
                items: const [
                  DropdownMenuItem(value: 'system', child: Text('System')),
                  DropdownMenuItem(value: 'light', child: Text('Light')),
                  DropdownMenuItem(value: 'dark', child: Text('Dark')),
                ],
                onChanged: (value) {
                  context.read<ThemeProvider>().setThemeMode(value ?? 'system');
                },
              ),
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.color_lens_outlined),
              title: const Text('Color Scheme'),
              trailing: DropdownButton(
                value: context.watch<ThemeProvider>().colorScheme,
                items: const [
                  DropdownMenuItem(
                      value: 'default', child: Text('Default Blue')),
                  DropdownMenuItem(value: 'nordic', child: Text('Nordic')),
                  DropdownMenuItem(
                      value: 'green_apple', child: Text('Green Apple')),
                  DropdownMenuItem(value: 'lavender', child: Text('Lavender')),
                  DropdownMenuItem(
                      value: 'strawberry', child: Text('Strawberry')),
                  // DropdownMenuItem(value: 'dracula', child: Text('Dracula')),
                  DropdownMenuItem(value: 'custom', child: Text('Custom'))
                ],
                onChanged: (value) {
                  context
                      .read<ThemeProvider>()
                      .setColorScheme(value ?? 'default');
                },
              ),
            ),
            if (context.watch<ThemeProvider>().useCustomTheme)
              ListTile(
                iconColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.draw),
                title: const Text('Custom Color Scheme'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CustomThemePage())),
              ),
            const Divider(),
            sectionTitle(
              'Other',
              Theme.of(context).colorScheme.secondary,
              padding: 10,
            ),
            ListTile(
              iconColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(Icons.functions),
              title: const Text('LaTeX Support'),
              subtitle: const Text('Markup for mathematical symbols'),
              trailing: Switch(
                  value: context.watch<SettingsProvider>().useLatex,
                  onChanged: (value) {
                    context.read<SettingsProvider>().setLatexUse(value);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
