import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';
import 'package:printnotes/utils/storage_system.dart';

class DeletedScreen extends StatefulWidget {
  const DeletedScreen({super.key});

  @override
  State<DeletedScreen> createState() => _DeletedScreenState();
}

class _DeletedScreenState extends State<DeletedScreen> {
  List<FileSystemEntity> _deletedItems = [];
  String _currentPath = '';
  String _currentFolderName = 'Trash';
  final List<String> _folderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadDeletedItems();
  }

  Future<void> _loadDeletedItems([String? folderPath]) async {
    final deletePath = await StorageSystem.getDeletedPath();
    final currentPath = folderPath ?? deletePath;
    final items = StorageSystem.listFolderContents(currentPath);
    setState(() {
      _deletedItems = items;
      _currentPath = currentPath;
      _currentFolderName =
          _currentPath == deletePath ? 'Trash' : path.basename(currentPath);
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
              ListTile(
                leading: Icon(
                  Icons.unarchive,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Restore'),
                onTap: () {
                  Navigator.pop(context);
                  ItemDeletionHandler.handleRestoringDeletedItem(
                      context, item, () => _loadDeletedItems(_currentPath));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Permanently Delete'),
                onTap: () {
                  Navigator.pop(context);
                  ItemDeletionHandler.showPermanentDeleteConfirmation(
                      context, item, () => _loadDeletedItems(_currentPath));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _deletedItems[index];
    final isDirectory = item is Directory;
    final name = path.basename(item.path);

    return GestureDetector(
      onTap: () {
        if (isDirectory) {
          _loadDeletedItems(item.path);
          ItemNavHandler.addToFolderHistory(_currentPath,
              dirHistory: _folderHistory);
        } else {
          ItemNavHandler.routeItemToPage(
              context, item, () => _loadDeletedItems(_currentPath));
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
                : Theme.of(context).colorScheme.secondary.withOpacity(0.8),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(_currentFolderName),
        leading: _folderHistory.length > 1
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  setState(() => _loadDeletedItems(
                      ItemNavHandler.navigateBack(dirHistory: _folderHistory)));
                },
              )
            : null,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'delAll') {
                for (final item in _deletedItems) {
                  ItemDeletionHandler.handlePermanentItemDelete(
                      context, item, () => _loadDeletedItems());
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
        ],
      ),
      body: _deletedItems.isEmpty
          ? const Center(
              child: Text('This folder is empty'),
            )
          : ListView.builder(
              itemCount: _deletedItems.length,
              itemBuilder: (context, index) {
                return _buildItem(context, index);
              },
            ),
    );
  }
}
