import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/centered_page_wrapper.dart';
import 'package:printnotes/ui/components/dialogs/basic_popup.dart';

import 'package:printnotes/ui/widgets/menu_tile.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

import 'package:printnotes/ui/screens/settings/more_design_options_page.dart';
import 'package:printnotes/ui/screens/settings/custom_theme_page.dart';
import 'package:printnotes/ui/screens/settings/codeblock_theme_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      return text != null ? MenuTile.subtitleText(context, text: text) : null;
    }

    bool canPureDarkMode = Theme.brightnessOf(context) != Brightness.light &&
        !context.watch<ThemeProvider>().useCustomTheme &&
        !context.watch<ThemeProvider>().useDynamicColor;
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
        child: CenteredPageWrapper(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              if (!Platform.isIOS)
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        'Storage Location',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        context.watch<SettingsProvider>().mainDir,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface),
                            foregroundColor:
                                Theme.of(context).colorScheme.onSurface,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            fixedSize: const Size(250, 40)),
                        onPressed: () async {
                          final pickedDirectory =
                              await DataPath.pickDirectory();
                          if (pickedDirectory != null && context.mounted) {
                            context
                                .read<SettingsProvider>()
                                .setMainDir(pickedDirectory);
                            context
                                .read<NavigationProvider>()
                                .initRouteHistory(pickedDirectory);
                          }
                        },
                        child: Text(
                          'Change Folder',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!Platform.isIOS) const SizedBox(height: 20),
              sectionTitle(
                'Sorting',
                Theme.of(context).colorScheme.secondary,
                padding: 10,
              ),
              MenuTile(
                leading: const Icon(Icons.sort),
                title: 'Sort Order',
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
                          value: 'lastModDsc', child: Text('Last Mod (Desc)')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsProvider>().setSortOrder(value);
                      }
                    }),
                isFirst: true,
              ),
              MenuTile(
                leading: const Icon(Icons.folder_copy_outlined),
                title: 'Folder Sort Priority',
                subtitle: MenuTile.subtitleText(context,
                    text: 'Display folders above or below files'),
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
                isLast: true,
              ),
              sectionTitle(
                'Styling',
                Theme.of(context).colorScheme.secondary,
                padding: 10,
              ),
              MenuTile(
                leading: const Icon(Icons.view_module),
                title: 'Layout Mode',
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
                        context
                            .read<SelectingProvider>()
                            .setSelectingMode(mode: false);
                      }
                    }),
                isFirst: true,
              ),
              MenuTile(
                leading: const Icon(
                  Icons.light_mode_outlined,
                ),
                title: 'Theme Mode',
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
              MenuTile(
                enabled: !context.watch<ThemeProvider>().useDynamicColor,
                leading: const Icon(Icons.color_lens_outlined),
                title: 'Color Scheme',
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
                  onChanged: context.watch<ThemeProvider>().useDynamicColor
                      ? null
                      : (String? value) {
                          context
                              .read<ThemeProvider>()
                              .setColorScheme(value ?? 'default');
                        },
                ),
              ),
              if (context.watch<ThemeProvider>().useCustomTheme)
                MenuTile(
                  enabled: !context.watch<ThemeProvider>().useDynamicColor,
                  leading: const Icon(Icons.draw),
                  title: 'Custom Color Scheme',
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: context.watch<ThemeProvider>().useDynamicColor
                      ? null
                      : () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CustomThemePage())),
                ),
              if (!Platform.isIOS)
                MenuTile(
                  leading: const Icon(Icons.devices),
                  title: 'Use Dynamic Colors',
                  subtitle: MenuTile.subtitleText(context,
                      text: 'Get theme based on your device'),
                  trailing: Switch(
                    value: context.watch<ThemeProvider>().useDynamicColor,
                    onChanged: (value) =>
                        context.read<ThemeProvider>().setDynamicColor(value),
                  ),
                ),
              MenuTile(
                enabled: canPureDarkMode,
                leading: const Icon(Icons.dark_mode),
                title: 'Pure black dark mode',
                trailing: Switch(
                    value: context.watch<ThemeProvider>().pureBlack,
                    onChanged: !canPureDarkMode
                        ? null
                        : (val) =>
                            context.read<ThemeProvider>().setPureBlackBG(val)),
              ),
              MenuTile(
                leading: const Icon(Icons.dashboard_customize),
                title: 'More Options',
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MoreDesignOptionsPage(),
                )),
                isLast: true,
              ),
              sectionTitle(
                'Advanced',
                Theme.of(context).colorScheme.secondary,
                padding: 10,
              ),
              if (Platform.isLinux || Platform.isWindows)
                MenuTile(
                    leading: const Icon(Icons.title),
                    title: 'Hide TitleBar',
                    subtitle: MenuTile.subtitleText(context,
                        text: 'Reload app to see changes'),
                    trailing: Switch(
                        value: context.watch<SettingsProvider>().hideTitleBar,
                        onChanged: (value) {
                          context
                              .read<SettingsProvider>()
                              .setTitleBarVisibility(value);
                        }),
                    isFirst: true),
              MenuTile(
                leading: const Icon(Icons.code),
                title: 'Code Wrapper Theme',
                subtitle: MenuTile.subtitleText(context,
                    text: 'Change theme for codeblocks'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CodeblockThemePage())),
                isFirst:
                    (Platform.isLinux || Platform.isWindows) ? false : true,
              ),
              MenuTile(
                leading: const Icon(Icons.functions),
                title: 'LaTeX Support',
                subtitle: MenuTile.subtitleText(context,
                    text: 'Markup for mathematical symbols'),
                trailing: Switch(
                    value: context.watch<SettingsProvider>().useLatex,
                    onChanged: (value) {
                      context.read<SettingsProvider>().setLatexUse(value);
                    }),
              ),
              MenuTile(
                leading: const Icon(Icons.label_important),
                title: 'Frontmatter Support',
                subtitle: MenuTile.subtitleText(context,
                    text: 'Used to read certain syntax as metadata'),
                trailing: Switch(
                    value: context.watch<SettingsProvider>().useFrontmatter,
                    onChanged: (value) {
                      context.read<SettingsProvider>().setFrontMatterUse(value);
                    }),
                isLast: true,
              ),
              const SizedBox(height: 12),
              MenuTile(
                leading: const Icon(Icons.data_array),
                title: 'Delete main_config.json',
                subtitle: MenuTile.subtitleText(context,
                    text: 'Resets certain configurations'),
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
                isFirst: true,
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
