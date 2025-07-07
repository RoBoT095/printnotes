import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/theme_provider.dart';

import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

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
                value: context.watch<ThemeProvider>().themeModeString,
                items: const [
                  DropdownMenuItem(value: 'system', child: Text('System')),
                  DropdownMenuItem(value: 'light', child: Text('Light')),
                  DropdownMenuItem(value: 'dark', child: Text('Dark')),
                ],
                onChanged: (value) {
                  context.read<ThemeProvider>().setThemeMode(value ?? 'system');
                },
              ),
              const SizedBox(height: 20),
              const Text("Select a color scheme for your app:"),
              DropdownButton<String>(
                value: context.watch<ThemeProvider>().colorScheme,
                items: const [
                  DropdownMenuItem(
                      value: 'default', child: Text('Default Blue')),
                  DropdownMenuItem(value: 'nordic', child: Text('Nordic')),
                  DropdownMenuItem(
                      value: 'green_apple', child: Text('Green Apple')),
                  DropdownMenuItem(value: 'lavender', child: Text('Lavender')),
                  DropdownMenuItem(
                      value: 'strawberry', child: Text('Strawberry')),
                ],
                onChanged: (value) {
                  context
                      .read<ThemeProvider>()
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
        if (!Platform.isIOS)
          PageViewModel(
            title: "Choose Your Notes Folder",
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (Platform.isAndroid)
                  Card(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainer
                        .withValues(alpha: 0.6),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "If you change folder location, you will be prompted to allow \"All File Access\" as it is needed for app to function properly!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (Platform.isAndroid) const SizedBox(height: 20),
                const Text("Select a folder to store your notes:"),
                ListTile(
                  title: const Center(child: Text('Notes Location:')),
                  subtitle: Center(
                      child: Text(context.watch<SettingsProvider>().mainDir)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String? selectedDirectory = await DataPath.pickDirectory();
                    if (selectedDirectory != null && context.mounted) {
                      context
                          .read<SettingsProvider>()
                          .setMainDir(selectedDirectory);
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
        PageViewModel(
          title: "Internet Usage",
          body:
              "This app uses internet access solely for the purpose of loading images from external URLs when rendered through Markdown or HTML.\n\nNo additional data is transmitted, collected, or stored as user privacy is important.",
          image: Center(
              child: Icon(
            Icons.wifi_lock,
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
        if (context.read<SettingsProvider>().mainDir != 'Not Set') {
          context.read<SettingsProvider>().setShowIntro(false);
        } else {
          customSnackBar('Please select a folder for your notes.',
                  type: 'warning')
              .show(context);
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
