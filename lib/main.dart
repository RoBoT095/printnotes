import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows) {
    windowManager.ensureInitialized();
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

  static late SharedPreferences localStorage;

  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadApp();
  }

  void loadApp() async {
    await App.init().then(
      (value) async {
        await _setTitleBarVisibility();
        await _checkStorageAccess();
        if (mounted) {
          final readSettings = context.read<SettingsProvider>();
          final readNavProv = context.read<NavigationProvider>();
          readNavProv.initRouteHistory(readSettings.mainDir);
        }
        setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _setTitleBarVisibility() async {
    final isTitleBarHidden = UserAdvancedPref.getTitleBarVisibility();
    if (Platform.isLinux || Platform.isWindows) {
      await windowManager.setTitleBarStyle(
          isTitleBarHidden ? TitleBarStyle.hidden : TitleBarStyle.normal);
    }
  }

  Future<void> _checkStorageAccess() async {
    final String? mainDir = await DataPath.selectedDirectory;
    final Directory defaultDir = await getApplicationDocumentsDirectory();
    final bool isNewUser = UserFirstTime.getShowIntro;

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
    if (_isLoading) {
      // Splash Screen to make sure everything loads in
      return Container(
        color: Color.fromRGBO(77, 143, 255, 1),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/app_icon_no-bg.png",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 100),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ],
        ),
      );
    }
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: themeProvider.useDynamicColor
                    ? (themeProvider.getThemeData(context).brightness ==
                            Brightness.light
                        ? lightDynamic
                        : darkDynamic)
                    : themeProvider.getThemeData(context)),
            themeMode: themeProvider.themeMode,
            title: 'Print(Notes)',
            home: const MainPage(),
          ),
        );
      },
    );
  }
}
