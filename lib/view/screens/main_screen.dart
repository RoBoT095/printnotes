// import 'dart:io';
import 'package:flutter/material.dart';

import 'package:printnotes/utils/load_settings.dart';

// import 'package:printnotes/utils/storage_system.dart';
// import 'package:printnotes/utils/configs/user_sort.dart';
import 'package:printnotes/view/components/main_scaffold.dart';

import 'package:printnotes/view/screens/intro_screen.dart';
import 'package:printnotes/view/screens/notes_display_screen.dart';
import 'package:printnotes/view/components/drawer.dart';
// import 'package:printnotes/view/components/widgets/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Maybe I should use something like riverpod or BLoC to handle state better
  bool firstTimeUser = true;
  bool isGrid = true;
  String? currentDirectory;
  // bool isSearching = false;
  // List<FileSystemEntity> searchResults = [];
  String? selectedFilePath;

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
        : Row(
            children: [
              if (screenWidth >= breakpoint)
                SizedBox(
                    width: 240,
                    child: Drawer(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                      child: DrawerView(
                        onItemChanged: _loadSettings,
                      ),
                    )),
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
                            onItemChanged: _loadSettings,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          );
  }
}
