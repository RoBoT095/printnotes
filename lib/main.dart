import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/editor_config_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/customization_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_preference.dart';
import 'package:printnotes/utils/configs/user_intro.dart';
import 'package:printnotes/ui/screens/home/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows) {
    await windowManager.ensureInitialized();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => EditorConfigProvider()),
        ChangeNotifierProvider(create: (_) => SelectingProvider()),
        ChangeNotifierProvider(create: (_) => CustomizationProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _checkStorageAccess();
    _setTitleBarVisibility();
  }

  void _setTitleBarVisibility() async {
    final isTitleBarHidden = await UserAdvancedPref.getTitleBarVisibility();
    if (Platform.isLinux || Platform.isWindows) {
      windowManager.setTitleBarStyle(
          isTitleBarHidden ? TitleBarStyle.hidden : TitleBarStyle.normal);
    }
  }

  void _checkStorageAccess() async {
    final String? mainDir = await DataPath.selectedDirectory;
    final Directory defaultDir = await getApplicationDocumentsDirectory();
    final bool isNewUser = await UserFirstTime.getShowIntro;

    if (mainDir != null) {
      if (Platform.isAndroid &&
          isNewUser != true &&
          mainDir != defaultDir.path) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          throw "Please allow storage permission to access files";
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorScheme: themeProvider.getThemeData(context)),
          themeMode: themeProvider.themeMode,
          title: 'Print(Notes)',
          home: const MainPage(),
        );
      },
    );
  }
}
