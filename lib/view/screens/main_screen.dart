import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:printnotes/utils/load_settings.dart';

import 'package:printnotes/view/components/main_scaffold.dart';

import 'package:printnotes/view/screens/intro_screen.dart';
import 'package:printnotes/view/screens/notes_display_screen.dart';
import 'package:printnotes/view/components/drawer.dart';
import 'package:printnotes/view/components/exit_popup.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool firstTimeUser = true;
  bool isGrid = true;
  late String currentDirectory;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final showIntro = await SettingsLoader.getShowIntro();
    final settings = await SettingsLoader.loadSettings();
    setState(() {
      firstTimeUser = showIntro;
      switch (settings['layout']) {
        case 'grid':
          isGrid = true;
        case 'list':
          isGrid = false;
      }
      currentDirectory = settings['directory'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 1000.0;

    return firstTimeUser
        ? IntroScreen(onDone: () {
            setState(() {
              firstTimeUser = false;
              _loadSettings();
            });
          })
        : PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              final canPop = await showExitPopup(context);
              if (canPop && context.mounted) {
                SystemNavigator.pop();
              }
            },
            child: Row(
              children: [
                if (screenWidth >= breakpoint)
                  SizedBox(
                    width: 240,
                    child: Drawer(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                      child: DrawerView(
                        directory: currentDirectory,
                        onItemChanged: _loadSettings,
                      ),
                    ),
                  ),
                if (screenWidth >= breakpoint)
                  Container(
                    width: 0.5,
                    color: Colors.black,
                  ),
                Expanded(
                  child: MainScaffold(
                    title: widget.title,
                    currentDirectory: currentDirectory,
                    isGrid: () {
                      setState(() {
                        isGrid = !isGrid;
                      });
                    },
                    body: NotesDisplay(
                      key: ValueKey(currentDirectory),
                      isLayoutGrid: isGrid,
                      currentDirectory: currentDirectory,
                      onStateChanged: _loadSettings,
                    ),
                    drawer: screenWidth < breakpoint
                        ? Drawer(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: DrawerView(
                              directory: currentDirectory,
                              onItemChanged: _loadSettings,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          );
  }
}
