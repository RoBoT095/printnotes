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
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _canPop = false;
  VoidCallback? _reloadCallback;

  void _handleReload(VoidCallback callback) {
    _reloadCallback = callback;
  }

  void _updateCanPop() => setState(() => _canPop = !_canPop);

  @override
  Widget build(BuildContext context) {
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
            child: MainScaffold(
              body: NotesDisplay(
                key: ValueKey(context.watch<SettingsProvider>().mainDir),
                updateCanPop: _updateCanPop,
                onReload: _handleReload,
              ),
              drawer: Drawer(
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: DrawerView(
                  reload: () {
                    if (_reloadCallback != null) {
                      _reloadCallback!();
                    }
                  },
                ),
              ),
            ),
          );
  }
}
