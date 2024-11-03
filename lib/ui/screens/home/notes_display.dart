import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:printnotes/ui/screens/home/layout/grid_list_view.dart';
import 'package:printnotes/utils/configs/user_preference.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';

import 'package:printnotes/ui/screens/home/layout/tree_view.dart';
import 'package:printnotes/ui/widgets/speed_dial_fab.dart';

class NotesDisplay extends StatefulWidget {
  const NotesDisplay({
    super.key,
    required this.currentLayout,
    required this.currentDirectory,
    required this.onStateChanged,
    required this.updateCanPop,
  });

  final String currentLayout;
  final String currentDirectory;
  final VoidCallback onStateChanged;
  final VoidCallback updateCanPop;

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  bool _isLoading = false;
  List<FileSystemEntity> _items = [];
  String _currentPath = '';
  String _currentFolderName = 'All Notes';
  List<String> _folderHistory = [];
  bool _useLatex = false;
  int _previewLength = 100;

  @override
  void initState() {
    super.initState();
    _loadItems(widget.currentDirectory, doReload: true);
  }

  // If settings were changed, update UI
  @override
  void didUpdateWidget(NotesDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLayout != widget.currentLayout ||
        oldWidget.currentDirectory != widget.currentDirectory) {
      _loadItems(widget.currentDirectory, doReload: true);
    } else {
      _loadItems(oldWidget.currentDirectory, doReload: true);
    }
  }

  Future<void> _loadItems(String? folderPath, {bool doReload = false}) async {
    ItemNavHandler.initializeFolderHistory();
    final loadedItems = await SettingsLoader.loadItems(
      folderPath: folderPath,
      doReload: doReload,
    );
    bool userLatexPref = await UserLatexPref.getLatexSupport();
    int userPreviewLength = await UserLayoutPref.getNotePreviewLength();

    if (mounted) {
      setState(() {
        _useLatex = userLatexPref;
        _previewLength = userPreviewLength;

        _items = loadedItems['items'];
        _currentPath = loadedItems['currentPath'];
        _currentFolderName = loadedItems['currentFolderName'];
        _folderHistory = ItemNavHandler.folderHistory;
      });
    }
  }

  void _navBack() {
    setState(() {
      _loadItems(ItemNavHandler.navigateBack());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_folderHistory.length > 1) {
          _navBack();
        } else {
          widget.updateCanPop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(_currentFolderName),
          leading: _folderHistory.length > 1
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _navBack,
                )
              : null,
          actions: [
            IconButton(
              tooltip: 'Reload List',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() => _isLoading = true);
                _loadItems(_currentPath);
                Timer(const Duration(milliseconds: 300),
                    () => setState(() => _isLoading = false));
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? const Center(
                    child: Text('Nothing here!'),
                  )
                : widget.currentLayout == 'tree'
                    ? TreeLayoutView(
                        initDir: widget.currentDirectory,
                        onChange: () => _loadItems(_currentPath),
                      )
                    : GridListView(
                        items: _items,
                        onChange: (value) => _loadItems(value),
                        currentPath: _currentPath,
                        currentLayout: widget.currentLayout,
                        latexSupport: _useLatex,
                        notePreviewLength: _previewLength,
                      ),
        floatingActionButton: speedDialFAB(
          context,
          currentPath: _currentPath,
          onLoadItems: () => _loadItems(_currentPath),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
