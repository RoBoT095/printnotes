import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_intro.dart';
import 'package:printnotes/ui/screens/home/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SelectingProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const App(),
    ),
  );
}

Future<void> initializeApp() async {
  await DataPath.selectedDirectory;
  var isNewUser = await UserFirstTime.getShowIntro;
  if (Platform.isAndroid && isNewUser != true) {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      throw "Please allow storage permission to access files";
    }
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorScheme: themeProvider.getThemeData(context)),
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
