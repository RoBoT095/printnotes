import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/dialogs/basic_popup.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

import 'package:printnotes/ui/screens/settings/more_design_options_page.dart';
import 'package:printnotes/ui/screens/settings/custom_theme_page.dart';
import 'package:printnotes/ui/screens/settings/codeblock_theme_page.dart';

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
    bool isScreenLarge = screenWidth >= 800;

    Widget? getSortOrderSubtitle() {
      String sortOrder = context.watch<SettingsProvider>().sortOrder;
      String? text;
      switch (sortOrder) {
        case 'default':
          text = 'Varies on system';
          break;
        case 'titleAsc':
          text = 'Sorted a,b,c...';
          break;
        case 'titleDsc':
          text = 'Sorted z,y,x...';
          break;
        case 'lastModAsc':
          text = 'Newer towards bottom';
          break;
        case 'lastModDsc':
          text = 'Newer towards top';
          break;
        default:
          text = null;
      }
      return text != null ? Text(text) : null;
    }

    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text('Settings'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: isScreenLarge
              ? EdgeInsets.symmetric(
                  horizontal: (MediaQuery.sizeOf(context).width - 800) / 2)
              : null,
          child: ListTileTheme(
            iconColor: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                if (!Platform.isIOS)
                  ListTile(
                    title: const Text('Notes Storage Location'),
                    subtitle: Text(context.watch<SettingsProvider>().mainDir),
                    trailing: const Icon(Icons.folder),
                    onTap: () async {
                      final pickedDirectory = await DataPath.pickDirectory();
                      if (pickedDirectory != null && context.mounted) {
                        context
                            .read<SettingsProvider>()
                            .setMainDir(pickedDirectory);
                        context.read<NavigationProvider>().initRouteHistory(
                            context.read<SettingsProvider>().mainDir);
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(250, 40)),
                        onPressed: () async {
                          final pickedDirectory =
                              await DataPath.pickDirectory();
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
                  leading: const Icon(Icons.view_module),
                  title: const Text('Layout Mode'),
                  trailing: DropdownButton(
                      value: context.watch<SettingsProvider>().layout,
                      items: const [
                        DropdownMenuItem(
                            value: 'grid', child: Text('Grid View')),
                        DropdownMenuItem(
                            value: 'list', child: Text('List View')),
                        DropdownMenuItem(
                            value: 'tree', child: Text('Tree View')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsProvider>().setLayout(value);
                          context
                              .read<SelectingProvider>()
                              .setSelectingMode(mode: false);
                        }
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt_rounded),
                  title: const Text('Note Preview amount'),
                  subtitle: Slider(
                    value: context
                        .watch<SettingsProvider>()
                        .previewLength
                        .toDouble(),
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
                  'Sorting',
                  Theme.of(context).colorScheme.secondary,
                  padding: 10,
                ),
                ListTile(
                  leading: const Icon(Icons.sort),
                  title: const Text('Sort Order'),
                  subtitle: getSortOrderSubtitle(),
                  trailing: DropdownButton(
                      value: context.watch<SettingsProvider>().sortOrder,
                      items: const [
                        DropdownMenuItem(
                            value: 'default', child: Text('Default Order')),
                        DropdownMenuItem(
                            value: 'titleAsc', child: Text('Title (Asc)')),
                        DropdownMenuItem(
                            value: 'titleDsc', child: Text('Title (Desc)')),
                        DropdownMenuItem(
                            value: 'lastModAsc', child: Text('Last Mod (Asc)')),
                        DropdownMenuItem(
                            value: 'lastModDsc',
                            child: Text('Last Mod (Desc)')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsProvider>().setSortOrder(value);
                        }
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.folder_copy_outlined),
                  title: const Text('Folder Sort Priority'),
                  subtitle: const Text('Display folders above or below files'),
                  trailing: DropdownButton(
                      value: context.watch<SettingsProvider>().folderPriority,
                      items: const [
                        DropdownMenuItem(value: 'above', child: Text('Above')),
                        DropdownMenuItem(value: 'none', child: Text('None')),
                        DropdownMenuItem(value: 'below', child: Text('Below')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsProvider>()
                              .setFolderPriority(value);
                        }
                      }),
                ),
                const Divider(),
                sectionTitle(
                  'Style',
                  Theme.of(context).colorScheme.secondary,
                  padding: 10,
                ),
                ListTile(
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
                      context
                          .read<ThemeProvider>()
                          .setThemeMode(value ?? 'system');
                    },
                  ),
                ),
                ListTile(
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
                      DropdownMenuItem(
                          value: 'lavender', child: Text('Lavender')),
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
                    leading: const Icon(Icons.draw),
                    title: const Text('Custom Color Scheme'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CustomThemePage())),
                  ),
                if (context.watch<ThemeProvider>().themeModeString != 'light' &&
                    !context.watch<ThemeProvider>().useCustomTheme)
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text('Pure black dark mode'),
                    trailing: Switch(
                        value: context.watch<ThemeProvider>().pureBlack,
                        onChanged: (val) =>
                            context.read<ThemeProvider>().setPureBlackBG(val)),
                  ),
                ListTile(
                  leading: const Icon(Icons.dashboard_customize),
                  title: Text('More Design Options'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MoreDesignOptionsPage(),
                  )),
                ),
                const Divider(),
                sectionTitle(
                  'Advanced',
                  Theme.of(context).colorScheme.secondary,
                  padding: 10,
                ),
                if (Platform.isLinux || Platform.isWindows)
                  ListTile(
                    leading: const Icon(Icons.title),
                    title: const Text('Hide TitleBar'),
                    subtitle: const Text('Reload app to see changes'),
                    trailing: Switch(
                        value: context.watch<SettingsProvider>().hideTitleBar,
                        onChanged: (value) {
                          context
                              .read<SettingsProvider>()
                              .setTitleBarVisibility(value);
                        }),
                  ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Code Wrapper Theme'),
                  subtitle: const Text('Change theme for codeblocks'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CodeblockThemePage())),
                ),
                ListTile(
                  leading: const Icon(Icons.functions),
                  title: const Text('LaTeX Support'),
                  subtitle: const Text('Markup for mathematical symbols'),
                  trailing: Switch(
                      value: context.watch<SettingsProvider>().useLatex,
                      onChanged: (value) {
                        context.read<SettingsProvider>().setLatexUse(value);
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.label_important),
                  title: const Text('Frontmatter Support'),
                  subtitle:
                      const Text('Used to read certain syntax as metadata'),
                  trailing: Switch(
                      value: context.watch<SettingsProvider>().useFrontmatter,
                      onChanged: (value) {
                        context
                            .read<SettingsProvider>()
                            .setFrontMatterUse(value);
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.data_array),
                  title: const Text('Delete main_config.json'),
                  subtitle: const Text('Resets certain configurations'),
                  trailing: IconButton(
                      onPressed: () async {
                        final bool response = await showBasicPopup(
                            context,
                            'Delete Config File?',
                            'Are you sure you want to delete?\nThis will get rid of all custom themes and markdown toolbar modifications and restore defaults!');
                        if (response) {
                          DataPath.deleteJsonConfigFile;
                          if (context.mounted) {
                            customSnackBar('Generated new config file',
                                    type: 'success')
                                .show(context);
                          }
                        }
                      },
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).colorScheme.error)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
