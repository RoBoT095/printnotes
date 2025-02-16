import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';

import 'package:printnotes/ui/screens/home/main_scaffold.dart';
import 'package:printnotes/ui/screens/home/intro_screen.dart';
import 'package:printnotes/ui/screens/home/notes_display.dart';
import 'package:printnotes/ui/components/drawer.dart';
import 'package:printnotes/ui/components/dialogs/basic_popup.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _canPop = false;

  void _updateCanPop() => setState(() => _canPop = !_canPop);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const breakpoint = 1000.0;
    return context.watch<SettingsProvider>().showIntro
        ? const IntroScreen()
        : PopScope(
            canPop: _canPop,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (_canPop == true) {
                final exitPopup = await showBasicPopup(
                    context, 'Exit App', 'Do you want to exit Print(Notes)?');
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
                      child: const DrawerView(),
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
                    body: NotesDisplay(
                      key: ValueKey(context.watch<SettingsProvider>().mainDir),
                      updateCanPop: _updateCanPop,
                    ),
                    drawer: screenWidth < breakpoint
                        ? Drawer(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: const DrawerView(),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          );
  }
}
