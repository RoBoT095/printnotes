import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:printnotes/utils/handlers/custom_themes/theme_validator.dart';
import 'package:printnotes/utils/handlers/custom_themes/theme_json_handler.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';
import 'package:printnotes/ui/widgets/list_section_title.dart';

class CustomThemePage extends StatefulWidget {
  const CustomThemePage({super.key});

  @override
  State<CustomThemePage> createState() => _CustomThemePageState();
}

class _CustomThemePageState extends State<CustomThemePage> {
  final _formKey = GlobalKey<FormState>();
  final _themeName = TextEditingController();
  final _themeJsonString = TextEditingController();
  // Map for storing custom colors and its index for each theme mode
  // TODO: Save selected color schemes to either config file or shared preference
  Map<String, int> isCustomColorSelected = {"dark": -1, "light": -1};
  List darkThemes = [];
  List lightThemes = [];
  late Map<String, dynamic> copiedForUndo;

  @override
  void initState() {
    refreshThemeList();
    super.initState();
  }

  void refreshThemeList() {
    darkThemes = listDarkThemeFromConfig();
    lightThemes = listLightThemeFromConfig();
  }

  Future<void> _launchUrl(url) async {
    url = Uri.parse(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void addItemBack() {
    addThemeToConfig(CustomThemeJson.fromJson(copiedForUndo.toString()));
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

  Widget buildCustomThemeListTile(List<dynamic> list, int index) {
    double circleRadius = 12;
    var isDark = false;
    bool isSelected = false;
    if (0 == list[index]["brightness"]) isDark = true;

    isSelected = isCustomColorSelected[isDark ? "dark" : "light"] == index;

    return Dismissible(
      key: ValueKey(list[index]),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(list[index]);
        // if the custom color that got deleted is selected, reset those values
        setState(() {
          if (isSelected == true) {
            isSelected = false;
            // TODO: don't forget to actually test this later
            isCustomColorSelected[isDark ? "dark" : "light"] = -1;
          }
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
          setState(
              () => isCustomColorSelected[isDark ? "dark" : "light"] = index);
        },
        trailing: isSelected ? const Icon(Icons.check) : null,
        // TODO: add title overflow handling
        title: Text(list[index]['name']),
        subtitle: SizedBox(
          width: ((circleRadius * 2) * 7) + 20,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Colors')),
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
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                    controller: _themeName,
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
                      if (name == null || name.isEmpty) {
                        return 'Please enter a name for theme';
                      }
                      if (!validateCustomThemeName(name)) {
                        return 'Name is already in use';
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
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
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

                          ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar('Saved Successfully'));
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
              child:
                  Text('Switch theme mode on settings screen to see changes')),
          const Divider(),
          // List of light themes, ones with int of 1
          sectionTitle(
            'Light Theme',
            Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: lightThemes.length,
              itemBuilder: (context, index) {
                return buildCustomThemeListTile(lightThemes, index);
              },
            ),
          ),
          const Divider(),
          // List of dark themes, ones with int of 0
          sectionTitle(
            'Dark Theme',
            Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: darkThemes.length,
              itemBuilder: (context, index) {
                return buildCustomThemeListTile(darkThemes, index);
              },
            ),
          )
        ],
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


// TODO: Remove this later
// Valid theme for testing
// {"brightness": 1, "primary": 4294921554, "onPrimary": 4294967295, "secondary": 4294945948, "onSecondary": 4294967295, "surface": 4294834424, "onSurface": 4278190080, "surfaceContainer": 4294376191}