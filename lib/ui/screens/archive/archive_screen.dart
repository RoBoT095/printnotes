import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/item_archive.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';
import 'package:printnotes/utils/storage_system.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<FileSystemEntity> _archivedItems = [];
  String _currentPath = '';
  String _currentFolderName = 'Archive';
  final List<String> _folderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadArchivedItems();
  }

  Future<void> _loadArchivedItems([String? folderPath]) async {
    final archivePath = await StorageSystem.getArchivePath();
    final currentPath = folderPath ?? archivePath;
    final items = await StorageSystem.listFolderContents(currentPath);
    setState(() {
      _archivedItems = items;
      _currentPath = currentPath;
      _currentFolderName =
          _currentPath == archivePath ? 'Archive' : path.basename(currentPath);
      ItemNavHandler.addToFolderHistory(currentPath,
          passHistory: _folderHistory);
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
                title: const Text('Unarchive'),
                onTap: () {
                  Navigator.pop(context);
                  ItemArchiveHandler.handleUnarchiveItem(
                      context, item, () => _loadArchivedItems(_currentPath));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  ItemDeletionHandler.showDeleteConfirmation(
                      context, item, () => _loadArchivedItems(_currentPath));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _archivedItems[index];
    final isDirectory = item is Directory;
    final name = path.basename(item.path);

    return GestureDetector(
      onTap: () {
        if (isDirectory) {
          _loadArchivedItems(item.path);
        } else {
          ItemNavHandler.onNoteSelect(
              context, item, () => _loadArchivedItems(_currentPath));
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
                  setState(() {
                    _loadArchivedItems(ItemNavHandler.navigateBack(
                        passHistory: _folderHistory));
                  });
                },
              )
            : null,
      ),
      body: _archivedItems.isEmpty
          ? const Center(
              child: Text('This folder is empty'),
            )
          : ListView.builder(
              itemCount: _archivedItems.length,
              itemBuilder: (context, index) {
                return _buildItem(context, index);
              },
            ),
    );
  }
}
