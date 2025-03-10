import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/utils/handlers/item_move.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';

import 'package:printnotes/ui/screens/layout/grid_list_view.dart';
import 'package:printnotes/ui/screens/layout/tree_view.dart';
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

  bool _isLoading = false;

  void _loadItems() {
    context
        .read<NavigationProvider>()
        .initRouteHistory(context.read<SettingsProvider>().mainDir);
    final loadedItems = context.read<SettingsProvider>().loadItems(
        context, context.read<NavigationProvider>().routeHistory.last);

    setState(() {
      _items = loadedItems['items'];
      _currentPath = loadedItems['currentPath'];
      _currentFolderName = loadedItems['currentFolderName'];
    });
  }

  void _navBack() => context.read<NavigationProvider>().navigateBack();

  Future<void> _refreshPage() async {
    setState(() => _isLoading = true);
    _loadItems();

    Future.delayed(const Duration(milliseconds: 300),
        () => setState(() => _isLoading = false));
  }

  List<FileSystemEntity> selectedItemsToFileEntity() {
    List<FileSystemEntity> fileList = [];
    for (var item in context.read<SelectingProvider>().selectedItems) {
      fileList.add(File(item));
    }
    return fileList;
  }

  @override
  Widget build(BuildContext context) {
    _loadItems();

    List<String> routeHistory =
        context.watch<NavigationProvider>().routeHistory;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (routeHistory.length > 1) {
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
              : routeHistory.length > 1
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
                          context, selectedItemsToFileEntity(), _loadItems);
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
                          context, selectedItemsToFileEntity(), _loadItems);
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
                    onPressed: _refreshPage,
                  ),
                ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? const Center(
                    child: Text('Nothing here!'),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshPage,
                    child: context.watch<SettingsProvider>().layout == 'tree'
                        ? TreeLayoutView(onChange: _loadItems)
                        : GridListView(items: _items, onChange: _loadItems),
                  ),
        floatingActionButton: speedDialFAB(
            context,
            _currentPath ?? context.read<SettingsProvider>().mainDir,
            _loadItems),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
