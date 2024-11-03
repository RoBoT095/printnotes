import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:printnotes/utils/load_settings.dart';

import 'package:printnotes/ui/screens/home/main_scaffold.dart';

import 'package:printnotes/ui/screens/home/intro_screen.dart';
import 'package:printnotes/ui/screens/home/notes_display.dart';
import 'package:printnotes/ui/components/drawer.dart';
import 'package:printnotes/ui/components/dialogs/exit_popup.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool firstTimeUser = true;
  String currentLayout = 'grid';
  late String currentDirectory;
  bool _canPop = false;

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
      currentLayout = settings['layout'];
      currentDirectory = settings['directory'];
    });
  }

  void _updateCanPop() {
    setState(() {
      _canPop = !_canPop;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const breakpoint = 1000.0;

    return firstTimeUser
        ? IntroScreen(onDone: () {
            setState(() {
              firstTimeUser = false;
              _loadSettings();
            });
          })
        : PopScope(
            canPop: _canPop,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (_canPop == true) {
                final exitPopup = await showExitPopup(context);
                if (exitPopup && context.mounted) {
                  SystemNavigator.pop();
                }
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
                    onChange: _loadSettings,
                    layoutChange: (value) =>
                        setState(() => currentLayout = value),
                    body: NotesDisplay(
                      key: ValueKey(currentDirectory),
                      currentLayout: currentLayout,
                      currentDirectory: currentDirectory,
                      onStateChanged: _loadSettings,
                      updateCanPop: _updateCanPop,
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
