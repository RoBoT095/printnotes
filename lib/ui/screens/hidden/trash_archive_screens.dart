import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/utils/handlers/item_archive.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';
import 'package:printnotes/utils/storage_system.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';

class TrashArchiveScreen extends StatefulWidget {
  const TrashArchiveScreen({super.key, required this.screenName});

  final String screenName;

  @override
  State<TrashArchiveScreen> createState() => _TrashArchiveScreenState();
}

class _TrashArchiveScreenState extends State<TrashArchiveScreen> {
  bool isTrash = true;
  List<FileSystemEntity> _hiddenItems = [];
  String _currentPath = '';
  String _currentFolderName = '';

  @override
  void initState() {
    super.initState();
    _loadHiddenItems();
  }

  Future<void> _loadHiddenItems([String? folderPath]) async {
    setState(
        () => widget.screenName == 'Trash' ? isTrash = true : isTrash = false);

    final hiddenPath = isTrash
        ? context.read<SettingsProvider>().trashPath
        : context.read<SettingsProvider>().archivePath;
    final currentPath = folderPath ?? hiddenPath;

    final items = await StorageSystem.listFolderContents(
      currentPath,
      showHidden: true,
    );

    setState(() {
      _hiddenItems = items;
      _currentPath = currentPath;
      _currentFolderName = _currentPath == hiddenPath
          ? widget.screenName
          : path.basename(currentPath);
    });
  }

  void _showBottomSheet(BuildContext context, FileSystemEntity item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!isTrash)
                ListTile(
                  leading: Icon(
                    Icons.unarchive,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: const Text('Unarchive'),
                  onTap: () {
                    Navigator.pop(context);
                    ItemArchiveHandler.handleUnarchiveItem(
                        context, item, () => _loadHiddenItems(_currentPath));
                  },
                ),
              if (!isTrash)
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    ItemDeletionHandler.showTrashConfirmation(
                        context, item, () => _loadHiddenItems(_currentPath));
                  },
                ),
              if (isTrash)
                ListTile(
                  leading: Icon(
                    Icons.unarchive,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: const Text('Restore'),
                  onTap: () {
                    Navigator.pop(context);
                    ItemDeletionHandler.handleRestoringDeletedItem(
                        context, item, () => _loadHiddenItems(_currentPath));
                  },
                ),
              if (isTrash)
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text('Permanently Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    ItemDeletionHandler.showPermanentDeleteConfirmation(
                        context, item, () => _loadHiddenItems(_currentPath));
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _hiddenItems[index];
    final isDirectory = item is Directory;
    final name = path.basename(item.path);

    return GestureDetector(
      onTap: () {
        if (isDirectory) {
          _loadHiddenItems(item.path);
          context.read<NavigationProvider>().addToRouteHistory(item.path);
        } else {
          context.read<NavigationProvider>().routeItemToPage(context, item);
        }
      },
      onLongPress: () => _showBottomSheet(context, item),
      child: Card(
        child: ListTile(
          leading: Icon(
            isDirectory ? Icons.folder : Icons.description,
            size: 48,
            color: isDirectory
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.8),
          ),
          title: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: isDirectory ? const Icon(Icons.arrow_forward_ios) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDragWrapper(
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          title: Text(_currentFolderName),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: context.read<NavigationProvider>().routeHistory.last !=
                    (isTrash
                        ? context.read<SettingsProvider>().trashPath
                        : context.read<SettingsProvider>().archivePath)
                ? () => _loadHiddenItems(
                    context.read<NavigationProvider>().navigateBack())
                : () {
                    context.read<NavigationProvider>().navigateBack();
                    Navigator.pop(context);
                  },
          ),
          actions: isTrash
              ? [
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'delAll') {
                        for (final item in _hiddenItems) {
                          ItemDeletionHandler.handlePermanentItemDelete(
                              context, item, () => _loadHiddenItems());
                        }
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        value: 'delAll',
                        child: Text("Empty Out Bin"),
                      ),
                    ],
                  ),
                ]
              : null,
        ),
      ),
      body: _hiddenItems.isEmpty
          ? const Center(
              child: Text('This folder is empty'),
            )
          : ListView.builder(
              itemCount: _hiddenItems.length,
              itemBuilder: (context, index) {
                return _buildItem(context, index);
              },
            ),
    );
  }
}
