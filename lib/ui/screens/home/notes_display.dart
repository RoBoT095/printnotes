import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/configs/user_preference.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';

import 'package:printnotes/ui/screens/home/tree_view.dart';
import 'package:printnotes/ui/components/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';
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
  final String? currentDirectory;
  final VoidCallback onStateChanged;
  final VoidCallback updateCanPop;

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  bool _mounted = true;
  bool _isLoading = false;
  List<FileSystemEntity> _items = [];
  String? _currentPath;
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

    if (_mounted) {
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

  Widget _buildGridItem(BuildContext context, int index) {
    final item = _items[index];
    final isDirectory = item is Directory;
    final name = path.basename(item.path);

    return GestureDetector(
      onTap: () {
        if (isDirectory) {
          _loadItems(item.path);
          ItemNavHandler.addToFolderHistory(item.path);
        }
        if (item is File) {
          if (allowedNoteExtensions.any((ext) => item.path.endsWith(ext))) {
            ItemNavHandler.onNoteSelect(
                context, item, () => _loadItems(_currentPath),
                latexSupport: _useLatex);
          } else if (allowedImageExtensions
              .any((ext) => item.path.endsWith(ext))) {
            ItemNavHandler.onImageSelect(context, item);
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(customSnackBar('File format not supported!'));
          }
        }
      },
      onLongPress: () =>
          showBottomMenu(context, item, () => _loadItems(_currentPath)),
      child: AbsorbPointer(
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: isDirectory
              ? ListTile(
                  leading: Icon(
                    Icons.folder,
                    size: 34,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    name,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: (item is File &&
                          allowedImageExtensions
                              .any((ext) => item.path.endsWith(ext)))
                      ? Image.file(item)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.replaceAll(".md", ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            MarkdownBlock(
                              selectable: false,
                              data: StorageSystem.getNotePreview(item.path,
                                  previewLength: _previewLength),
                              config: theMarkdownConfigs(context,
                                  hideCodeButtons: true),
                              generator: theMarkdownGenerators(context,
                                  textScale: 0.95, useLatex: _useLatex),
                            ),
                          ],
                        )),
        ),
      ),
    );
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
                        initDir: widget.currentDirectory ?? '',
                        onChange: () => _loadItems(_currentPath))
                    : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(8),
                            sliver: SliverMasonryGrid.count(
                              crossAxisCount:
                                  _displayGridCount(widget.currentLayout),
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childCount: _items.length,
                              itemBuilder: (context, index) =>
                                  _buildGridItem(context, index),
                            ),
                          ),
                          // Adds empty space at bottom, helps when in list view
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 200,
                            ),
                          )
                        ],
                      ),
        floatingActionButton: speedDialFAB(
          context,
          currentPath: _currentPath ?? '',
          onLoadItems: () => _loadItems(_currentPath),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  int _displayGridCount(layout) {
    if (layout == 'list') {
      return 1;
    } else {
      double displayWidth = MediaQuery.sizeOf(context).width;
      if (displayWidth > 1200) {
        return 4;
      } else {
        return 2;
      }
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
