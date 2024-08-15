import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/themes/theme_provider.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_layout.dart';
import 'package:printnotes/utils/configs/user_sort.dart';

import 'package:printnotes/view/intro_screen.dart';
import 'package:printnotes/view/notes_screen.dart';
import 'package:printnotes/view/drawer_screens/drawer_list.dart';
import 'package:printnotes/view/components/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const App(),
  ));
}

Future<void> initializeApp() async {
  await DataPath.selectedDirectory;
  await StorageSystem.cleanupExpiredItems();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getThemeData(context),
          darkTheme: themeProvider.getThemeData(context),
          themeMode: themeProvider.themeMode,
          title: 'Print(Notes)',
          home: const MainPage(
            title: 'Print(Notes)',
          ),
        );
      },
    );
  }
}

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
  bool isSearching = false;
  List<FileSystemEntity> searchResults = [];
  String? selectedFilePath;
  String sortOrder = 'default';

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
      sortOrder = settings['sortOrder'];
      currentDirectory = settings['directory'];
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
        isSearching = false;
      });
      return;
    }

    final results =
        await StorageSystem.searchItems(query, currentDirectory ?? '');
    setState(() {
      searchResults = results;
      isSearching = true;
    });
  }

  void _sortItems(String order) {
    setState(() {
      UserSortPref.setSortOrder(order);
      sortOrder = order;
    });
  }

  Widget mainScaffold(String title, {required Widget body, Widget? drawer}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
              )
            : Text(title),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              isSearching = !isSearching;
              setState(() {
                if (!isSearching) {
                  searchResults.clear();
                }
              });
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            onSelected: _sortItems,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'default',
                child: Text('Default Order'),
              ),
              PopupMenuItem(
                value: 'titleAsc',
                child: Text('Title (Ascending)'),
              ),
              PopupMenuItem(
                value: 'titleDsc',
                child: Text('Title (Descending)'),
              ),
            ],
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'layoutSwitch') {
                setState(() {
                  isGrid = !isGrid;
                  UserLayoutPref.setLayoutView(isGrid ? 'grid' : 'list');
                });
              }
            },
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'layoutSwitch',
                child: Text("Switch Layout"),
              ),
            ],
          ),
        ],
      ),
      drawer: drawer,
      body: body,
    );
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
                      child: DrawerListView(
                        onItemChanged: _loadSettings,
                      ),
                    )),
              if (screenWidth >= breakpoint)
                Container(
                  width: 0.5,
                  color: Colors.black,
                ),
              Expanded(
                child: mainScaffold(
                  widget.title,
                  body: isSearching && searchResults.isNotEmpty
                      ? buildSearchResults(searchResults, currentDirectory)
                      : NotesDisplay(
                          key: ValueKey(currentDirectory),
                          isLayoutGrid: isGrid,
                          currentDirectory: currentDirectory,
                          onStateChanged: _loadSettings,
                          sortOrder: sortOrder,
                        ),
                  drawer: screenWidth < breakpoint
                      ? Drawer(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          child: DrawerListView(
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
