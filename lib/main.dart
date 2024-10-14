import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/ui/screens/home/main_screen.dart';

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
