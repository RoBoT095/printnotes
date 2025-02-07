import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/item_move.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';

import 'package:printnotes/ui/components/layout/grid_list_view.dart';
import 'package:printnotes/ui/components/layout/tree_view.dart';
import 'package:printnotes/ui/widgets/speed_dial_fab.dart';

class NotesDisplay extends StatefulWidget {
  const NotesDisplay({
    super.key,
    required this.updateCanPop,
  });

  final VoidCallback updateCanPop;

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  List<FileSystemEntity> _items = [];
  String? _currentPath;
  String _currentFolderName = 'All Notes';
  List<String> _folderHistory = [];

  bool _isLoading = false;

  void _loadItems(String? path) {
    final loadedItems =
        context.read<SettingsProvider>().loadItems(context, folderPath: path);

    setState(() {
      _items = loadedItems['items'];
      _currentPath = loadedItems['currentPath'];
      _currentFolderName = loadedItems['currentFolderName'];
      _folderHistory = ItemNavHandler.folderHistory(
          context.read<SettingsProvider>().mainDir);
    });
  }

  void onChange(value) => _loadItems(value);

  void _navBack() => _loadItems(ItemNavHandler.navigateBack());

  List<FileSystemEntity> selectedItemsToFileEntity() {
    List<FileSystemEntity> fileList = [];
    for (var item in context.read<SelectingProvider>().selectedItems) {
      fileList.add(File(item));
    }
    return fileList;
  }

  @override
  Widget build(BuildContext context) {
    _loadItems(_currentPath);

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
          leading: context.watch<SelectingProvider>().selectingMode
              ? IconButton(
                  onPressed: () =>
                      context.read<SelectingProvider>().setSelectingMode(),
                  icon: const Icon(Icons.close))
              : _folderHistory.length > 1
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _navBack,
                    )
                  : null,
          actions: context.watch<SelectingProvider>().selectingMode
              ? [
                  IconButton(
                    tooltip: 'Select All',
                    onPressed: () {
                      context
                          .read<SelectingProvider>()
                          .selectAll(_currentPath!);
                    },
                    icon: const Icon(Icons.select_all),
                  ),
                  IconButton(
                    tooltip: 'Move Selected',
                    onPressed: () {
                      ItemMoveHandler.showMoveDialog(
                          context,
                          selectedItemsToFileEntity(),
                          () => _loadItems(_currentPath));
                      context
                          .read<SelectingProvider>()
                          .setSelectingMode(mode: false);
                    },
                    icon: const Icon(Icons.drive_file_move),
                  ),
                  IconButton(
                    tooltip: 'Delete Selected',
                    onPressed: () {
                      ItemDeletionHandler.showTrashManyConfirmation(
                          context,
                          selectedItemsToFileEntity(),
                          () => _loadItems(_currentPath));
                      context
                          .read<SelectingProvider>()
                          .setSelectingMode(mode: false);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ]
              : [
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
                : context.watch<SettingsProvider>().layout == 'tree'
                    ? TreeLayoutView(onChange: onChange)
                    : GridListView(items: _items, onChange: onChange),
        floatingActionButton: speedDialFAB(
          context,
          onLoadItems: () => _loadItems(_currentPath),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
