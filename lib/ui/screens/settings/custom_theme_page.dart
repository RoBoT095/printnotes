import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/theme_provider.dart';

import 'package:printnotes/utils/handlers/open_url_link.dart';
import 'package:printnotes/utils/config_file/custom_themes/custom_theme_model.dart';
import 'package:printnotes/utils/config_file/custom_themes/theme_validator.dart';
import 'package:printnotes/utils/config_file/custom_themes/theme_json_handler.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/centered_page_wrapper.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class CustomThemePage extends StatefulWidget {
  const CustomThemePage({super.key});

  @override
  State<CustomThemePage> createState() => _CustomThemePageState();
}

class _CustomThemePageState extends State<CustomThemePage> {
  int _selectedIndex = 0;
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

  Widget _buildThemeTile(List<dynamic> list, int index,
      {required bool isDark}) {
    double circleRadius = 10;

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
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
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
              child: Icon(
                isCustomColorSelected[isDark ? 'dark' : 'light'] ==
                        list[index]["name"]
                    ? Icons.check
                    : Icons.palette,
                color: Color(list[index]['onPrimary']),
              )),
          title: Text(
            list[index]["name"],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: SizedBox(
            width: ((circleRadius * 2) * 7) + 8,
            child: Row(
              children: <Widget>[
                _colorBox(list[index]["primary"]),
                _colorBox(list[index]["onPrimary"]),
                _colorBox(list[index]["secondary"]),
                _colorBox(list[index]["onSecondary"]),
                _colorBox(list[index]["surface"]),
                _colorBox(list[index]["onSurface"]),
                _colorBox(list[index]["surfaceContainer"]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorBox(int color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          centerTitle: true,
          title: const Text('Custom Colors'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        iconSize: 32,
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export),
            label: 'Import Themes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.light_mode),
            label: 'Light Mode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dark_mode),
            label: 'Dark Mode',
          ),
        ],
      ),
      body: [
        CenteredPageWrapper(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Theme Management',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: RichText(
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1.2),
                      text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            const TextSpan(
                                text: 'Make and import your theme from\n'),
                            TextSpan(
                              text: 'https://design.printnotes.app',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => urlHandler(
                                    context, 'https://design.printnotes.app'),
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
                                    .withValues(alpha: 0.6)),
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
                            hintText: 'Import json string for theme here...',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6)),
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
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String newCustomTheme = _themeJsonString.text
                                    .replaceFirst(
                                        '{', '{"name": "${_themeName.text}", ');

                                addThemeToConfig(
                                    CustomThemeJson.fromJson(newCustomTheme));

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
            : CenteredPageWrapper(
                child: ListView.builder(
                  itemCount: lightThemes.length,
                  itemBuilder: (context, index) {
                    return _buildThemeTile(
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
            : CenteredPageWrapper(
                child: ListView.builder(
                  itemCount: darkThemes.length,
                  itemBuilder: (context, index) {
                    return _buildThemeTile(
                      darkThemes,
                      index,
                      isDark: true,
                    );
                  },
                ),
              ),
      ][_selectedIndex],
    );
  }

  @override
  void dispose() {
    _themeName.dispose();
    _themeJsonString.dispose();
    super.dispose();
  }
}
