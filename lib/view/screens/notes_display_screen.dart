import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';

import 'package:printnotes/view/components/markdown/build_markdown.dart';
import 'package:printnotes/view/components/bottom_menu_popup.dart';
import 'package:printnotes/view/components/widgets/speed_dial_fab.dart';

class NotesDisplay extends StatefulWidget {
  const NotesDisplay({
    super.key,
    required this.isLayoutGrid,
    required this.currentDirectory,
    required this.onStateChanged,
    required this.updateCanPop,
  });

  final bool isLayoutGrid;
  final String? currentDirectory;
  final VoidCallback onStateChanged;
  final VoidCallback updateCanPop;

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  bool _mounted = true;
  List<FileSystemEntity> _items = [];
  String? _currentPath;
  String _currentFolderName = 'All Notes';
  List<String> _folderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadItems(widget.currentDirectory, doReload: true);
  }

  // If settings were changed, update UI
  @override
  void didUpdateWidget(NotesDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLayoutGrid != widget.isLayoutGrid ||
        oldWidget.currentDirectory != widget.currentDirectory) {
      _loadItems(widget.currentDirectory, doReload: true);
    } else {
      _loadItems(oldWidget.currentDirectory, doReload: true);
    }
  }

  // If you see unnecessary duplication of things, mind you I don't work in a straight
  // line, but like an impossible optical illusion of a spiral

  Future<void> _loadItems(String? folderPath, {bool doReload = false}) async {
    ItemNavHandler.initializeFolderHistory();
    final loadedItems = await SettingsLoader.loadItems(
      folderPath: folderPath,
      doReload: doReload,
    );

    if (_mounted) {
      setState(() {
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
        } else {
          ItemNavHandler.onNoteSelect(
              context, item, () => _loadItems(_currentPath));
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
                  child: Column(
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
                      FutureBuilder<String>(
                        future: StorageSystem.getNotePreview(item.path,
                            previewLength: 120),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return buildMarkdownView(
                              context,
                              selectable: false,
                              data: snapshot.data ?? 'Preview not available',
                              previewMode: true,
                            );
                          } else {
                            return const Text(
                              'Loading preview...',
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                            );
                          }
                        },
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
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _loadItems(_currentPath);
              },
            ),
          ],
        ),
        body: _items.isEmpty
            ? const Center(
                child: Text('Nothing here!'),
              )
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: _displayGridCount(widget.isLayoutGrid),
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

  int _displayGridCount(isLayoutGrid) {
    if (isLayoutGrid == false) return 1;
    double displayWidth = MediaQuery.of(context).size.width;
    if (displayWidth > 1200) {
      return 4;
    } else {
      return 2;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
