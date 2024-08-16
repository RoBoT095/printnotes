import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:printnotes/providers/theme_provider.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:printnotes/utils/configs/user_intro.dart';
import 'package:printnotes/utils/configs/data_path.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String selectedThemeMode = 'system';
  String selectedColorScheme = 'default';
  String? selectedDirectory;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsLoader.loadSettings();
    setState(() {
      selectedThemeMode = settings['theme'];
      selectedColorScheme = settings['colorScheme'];
      selectedDirectory = settings['directory'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Print(Notes)",
          body: "Your new favorite markdown notes app. Let's get you set up!",
          image: Center(
              child: Icon(
            Icons.code_rounded,
            size: 150.0,
            color: Theme.of(context).colorScheme.secondary,
          )),
        ),
        PageViewModel(
          title: "Choose Your Theme",
          bodyWidget: Column(
            children: [
              const Text("Select a theme mode:"),
              DropdownButton<String>(
                value: selectedThemeMode,
                items: const [
                  DropdownMenuItem(value: 'system', child: Text('System')),
                  DropdownMenuItem(value: 'light', child: Text('Light')),
                  DropdownMenuItem(value: 'dark', child: Text('Dark')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedThemeMode = value!;
                  });
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setThemeMode(value ?? 'system');
                },
              ),
              const SizedBox(height: 20),
              const Text("Select a color scheme for your app:"),
              DropdownButton<String>(
                value: selectedColorScheme,
                items: const [
                  DropdownMenuItem(value: 'default', child: Text('Default')),
                  DropdownMenuItem(
                      value: 'green_apple', child: Text('Green Apple')),
                  DropdownMenuItem(value: 'lavender', child: Text('Lavender')),
                  DropdownMenuItem(
                      value: 'strawberry', child: Text('Strawberry')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedColorScheme = value!;
                  });
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setColorScheme(value ?? 'default');
                },
              ),
            ],
          ),
          image: Center(
              child: Icon(
            Icons.color_lens,
            size: 150.0,
            color: Theme.of(context).colorScheme.secondary,
          )),
        ),
        PageViewModel(
          title: "Choose Your Notes Folder",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Select a folder to store your notes:"),
              ListTile(
                title: const Center(child: Text('Notes Location')),
                subtitle: Center(child: Text(selectedDirectory ?? 'Not Set')),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedDirectory = await DataPath.pickDirectory();
                  if (pickedDirectory != null) {
                    setState(() {
                      selectedDirectory = pickedDirectory;
                    });
                    await DataPath.setSelectedDirectory(pickedDirectory);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: const Text("Select Folder"),
              ),
            ],
          ),
          image: Center(
              child: Icon(
            Icons.folder,
            size: 150.0,
            color: Theme.of(context).colorScheme.secondary,
          )),
        ),
      ],
      showSkipButton: false,
      showNextButton: true,
      showDoneButton: true,
      next: Icon(
        Icons.arrow_forward_rounded,
        color: Theme.of(context).colorScheme.secondary,
        size: 30,
      ),
      done: Text("Done",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          )),
      onDone: () {
        if (selectedDirectory != null) {
          UserFirstTime.setShowIntro(false);
          widget.onDone();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Please select a folder for your notes.")),
          );
        }
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
