import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _loadArchivedItems();
  }

  void _loadArchivedItems([String? folderPath]) {
    final archivePath = context.read<SettingsProvider>().archivePath;
    final currentPath = folderPath ?? archivePath;
    final items =
        StorageSystem.listFolderContents(currentPath, showHidden: true);
    setState(() {
      _archivedItems = items;
      _currentPath = currentPath;
      _currentFolderName =
          _currentPath == archivePath ? 'Archive' : path.basename(currentPath);
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
                  ItemDeletionHandler.showPermanentDeleteConfirmation(
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
          context.read<NavigationProvider>().addToRouteHistory(_currentPath);
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
                : Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          ),
          title: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
          trailing:
              isDirectory ? const Icon(Icons.arrow_forward_ios_rounded) : null,
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
        leading: context.read<NavigationProvider>().routeHistory.length > 2
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  setState(() => _loadArchivedItems(
                      context.read<NavigationProvider>().navigateBack()));
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
