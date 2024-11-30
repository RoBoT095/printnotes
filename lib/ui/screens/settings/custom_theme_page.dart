import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/utils/config_file/custom_themes/theme_validator.dart';
import 'package:printnotes/utils/config_file/custom_themes/theme_json_handler.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class CustomThemePage extends StatefulWidget {
  const CustomThemePage({super.key});

  @override
  State<CustomThemePage> createState() => _CustomThemePageState();
}

class _CustomThemePageState extends State<CustomThemePage> {
  final _formKey = GlobalKey<FormState>();
  final _themeName = TextEditingController();
  final _themeJsonString = TextEditingController();
  List darkThemes = [];
  List lightThemes = [];
  // Map for storing custom colors and its name for each theme mode
  Map<String, dynamic> isCustomColorSelected = {"dark": "", "light": ""};
  late Map<String, dynamic> copiedForUndo;

  @override
  void initState() {
    isCustomColorSelected = loadSelectedThemeFromConfig();
    refreshThemeList();
    super.initState();
  }

  void refreshThemeList() {
    setState(() {
      darkThemes = listAllThemeFromConfig(isDark: true);
      lightThemes = listAllThemeFromConfig(isDark: false);
    });
  }

  Future<void> _launchUrl(url) async {
    url = Uri.parse(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void addItemBack() {
    restoreCustomTheme(copiedForUndo);
    refreshThemeList();
  }

  void removeItem(Map<String, dynamic> item) {
    copiedForUndo = item;
    deleteCustomTheme(item);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Removed custom theme'),
      action: SnackBarAction(label: 'Undo', onPressed: addItemBack),
    ));
  }

  // TODO: Redo this all, it looks ugly
  Widget buildCustomThemeListTile(List<dynamic> list, int index,
      {required bool isDark}) {
    double circleRadius = 12;

    return Dismissible(
      key: ValueKey(list[index]),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(list[index]);
        // if the custom color that got deleted is selected, reset those values
        setState(() {
          if (list[index]["name"] ==
              isCustomColorSelected[isDark ? 'dark' : 'light']) {
            isCustomColorSelected[isDark ? 'dark' : 'light'] = "";
          }
          refreshThemeList();
          Provider.of<ThemeProvider>(context, listen: false)
              .setColorScheme('custom');
        });
      },
      background: Container(
        color: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            isCustomColorSelected[isDark ? 'dark' : 'light'] =
                list[index]["name"];
            saveSelectedThemeToConfig(isCustomColorSelected);
            Provider.of<ThemeProvider>(context, listen: false)
                .setColorScheme('custom');
          });
        },
        leading: CircleAvatar(
          backgroundColor: Color(list[index]['primary']),
          child: isCustomColorSelected[isDark ? 'dark' : 'light'] ==
                  list[index]["name"]
              ? const Icon(Icons.check)
              : const Icon(Icons.palette),
        ),
        title: Text(
          list[index]["name"],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: SizedBox(
          width: ((circleRadius * 2) * 7) + 20,
          child: Card.filled(
            color: Color(list[index]['secondary']).withOpacity(0.2),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(list[index]['primary']),
                  radius: circleRadius,
                ),
                CircleAvatar(
                  backgroundColor: Color(list[index]['onPrimary']),
                  radius: circleRadius,
                ),
                CircleAvatar(
                  backgroundColor: Color(list[index]['secondary']),
                  radius: circleRadius,
                ),
                CircleAvatar(
                  backgroundColor: Color(list[index]['onSecondary']),
                  radius: circleRadius,
                ),
                CircleAvatar(
                  backgroundColor: Color(list[index]['surface']),
                  radius: circleRadius,
                ),
                CircleAvatar(
                  backgroundColor: Color(list[index]['onSurface']),
                  radius: circleRadius,
                ),
                CircleAvatar(
                  backgroundColor: Color(list[index]['surfaceContainer']),
                  radius: circleRadius,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    bool isScreenLarge = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Custom Colors'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).colorScheme.secondary,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 5,
              tabs: const <Tab>[
                Tab(
                    icon: Icon(Icons.download),
                    child: Text(
                      'Theme\n Management',
                      textAlign: TextAlign.center,
                    )),
                Tab(icon: Icon(Icons.light_mode), text: 'Light Mode'),
                Tab(icon: Icon(Icons.dark_mode), text: 'Dark Mode'),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: isScreenLarge
                        ? EdgeInsets.symmetric(
                            horizontal: (screenWidth - 600) / 2)
                        : null,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            title: RichText(
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1.2),
                                text: TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text:
                                              'Make and import your theme from\n'),
                                      TextSpan(
                                        text: 'https://design.printnotes.app',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => _launchUrl(
                                              'https://design.printnotes.app'),
                                      ),
                                    ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _themeName,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      hintText: 'Name your new theme...',
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6)),
                                    ),
                                    enableSuggestions: false,
                                    validator: (name) {
                                      if (name == null || name.isEmpty) {
                                        return 'Please enter a name for theme';
                                      }
                                      if (!validateCustomThemeName(name)) {
                                        return 'Name is already in use';
                                      }
                                      // How long title should be, can't decide what is a good length
                                      int titleLen = 35;
                                      if (name.length > titleLen) {
                                        return 'Name is too long, please keep it within $titleLen characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _themeJsonString,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(20))),
                                      hintText:
                                          'Import json string for theme here...',
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6)),
                                    ),
                                    enableSuggestions: false,
                                    validator: (theme) {
                                      if (theme == null || theme.isEmpty) {
                                        return 'Please input valid theme';
                                      }
                                      if (!validateCustomThemeJson(theme)) {
                                        return 'Json string is not valid';
                                      }
                                      return null;
                                    },
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          String newCustomTheme =
                                              _themeJsonString.text.replaceFirst(
                                                  '{',
                                                  '{"name": "${_themeName.text}", ');

                                          addThemeToConfig(
                                              CustomThemeJson.fromJson(
                                                  newCustomTheme));

                                          refreshThemeList();
                                          _themeName.clear();
                                          _themeJsonString.clear();

                                          customSnackBar('Saved Successfully',
                                                  type: 'success')
                                              .show(context);
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      child: const Text('Import'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Center(
                              child: Text(
                                  'Switch theme mode on settings screen to see changes')),
                        ],
                      ),
                    ),
                  ),
                  lightThemes.isEmpty
                      ? const Center(
                          child: Text('Import a Custom Light Theme'),
                        )
                      : Container(
                          margin: isScreenLarge
                              ? EdgeInsets.symmetric(
                                  horizontal: (screenWidth - 600) / 2)
                              : null,
                          child: ListView.builder(
                            itemCount: lightThemes.length,
                            itemBuilder: (context, index) {
                              return buildCustomThemeListTile(
                                lightThemes,
                                index,
                                isDark: false,
                              );
                            },
                          ),
                        ),
                  darkThemes.isEmpty
                      ? const Center(
                          child: Text('Import a Custom Dark Theme'),
                        )
                      : Container(
                          margin: isScreenLarge
                              ? EdgeInsets.symmetric(
                                  horizontal: (screenWidth - 600) / 2)
                              : null,
                          child: ListView.builder(
                            itemCount: darkThemes.length,
                            itemBuilder: (context, index) {
                              return buildCustomThemeListTile(
                                darkThemes,
                                index,
                                isDark: true,
                              );
                            },
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _themeName.dispose();
    _themeJsonString.dispose();
    super.dispose();
  }
}
