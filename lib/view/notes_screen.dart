import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:printnotes/styles/md_styles.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/load_settings.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';

import 'package:printnotes/view/components/bottom_menu_popup.dart';
import 'package:printnotes/view/components/speed_dial_fab.dart';
import 'package:printnotes/view/components/markdown_checkbox.dart';

class NotesDisplay extends StatefulWidget {
  const NotesDisplay({
    super.key,
    required this.isLayoutGrid,
    required this.currentDirectory,
    required this.onStateChanged,
    required this.sortOrder,
  });

  final bool isLayoutGrid;
  final String? currentDirectory;
  final VoidCallback onStateChanged;
  final String sortOrder;

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  bool _mounted = true;
  List<FileSystemEntity> _items = [];
  String? _mainPath;
  String? _currentPath;
  String _currentFolderName = 'All Notes';
  List<String> _folderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadItems(widget.currentDirectory, doReload: true);
  }

  @override
  void didUpdateWidget(NotesDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLayoutGrid != widget.isLayoutGrid ||
        oldWidget.currentDirectory != widget.currentDirectory ||
        oldWidget.sortOrder != widget.sortOrder) {
      _loadItems(widget.currentDirectory, doReload: true);
    } else {
      _loadItems(oldWidget.currentDirectory, doReload: true);
    }
  }

  // If you see unnecessary duplication of things, mind you I don't work in a straight
  // line, but like an impossible optical illusion of a spiral

  Future<void> _loadItems(String? folderPath, {bool doReload = false}) async {
    final result = await SettingsLoader.loadItems(
      folderPath: folderPath,
      sortOrder: widget.sortOrder,
      folderHistory: _folderHistory,
      doReload: doReload,
    );

    if (_mounted) {
      setState(() {
        _items = result['items'];
        _currentPath = result['currentPath'];
        _currentFolderName = result['currentFolderName'];
        _mainPath = result['mainPath'];
        _folderHistory = result['folderHistory'];
      });
    }
  }

  _getFolderName() {
    if (_currentFolderName != _mainPath) {
      return _currentFolderName;
    } else {
      return 'All Notes';
    }
  }

  Widget _buildGridItem(BuildContext context, int index) {
    final item = _items[index];
    final isDirectory = item is Directory;
    final name = path.basename(item.path);

    return GestureDetector(
      onTap: () {
        if (isDirectory) {
          _loadItems(item.path);
        } else {
          ItemNavHandler.handleNoteTap(
              context, item, () => _loadItems(_currentPath));
        }
      },
      onLongPress: () =>
          Menu.showBottomSheet(context, item, () => _loadItems(_currentPath)),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: isDirectory
            ? ListTile(
                leading: Icon(
                  Icons.folder,
                  size: 38,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name.replaceAll(".md", ''),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: StorageSystem.getNotePreview(item.path,
                          previewLength: 180),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return MarkdownBody(
                            data: snapshot.data ?? 'Preview not available',
                            softLineBreak: true,
                            styleSheet:
                                MainMarkDownStyles.mainMDStyles(context),
                            checkboxBuilder: (checked) =>
                                markdownCheckBox(checked),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(_getFolderName()),
        leading: _folderHistory.length > 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    ItemNavHandler.navigateBack(_folderHistory, _loadItems);
                  });
                },
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: _displayGridCount(widget.isLayoutGrid),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childCount: _items.length,
              itemBuilder: (context, index) => _buildGridItem(context, index),
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
      floatingActionButton: SpeedDialFAB(
        onLoadItems: () => _loadItems(_currentPath),
        currentPath: _currentPath ?? '',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
