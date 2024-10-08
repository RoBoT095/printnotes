import 'dart:io';

import 'package:flutter/material.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/configs/user_preference.dart';
import 'package:printnotes/ui/widgets/search.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
    required this.title,
    this.currentDirectory,
    required this.onChange,
    required this.isGrid,
    required this.body,
    this.drawer,
  });

  final String title;
  final String? currentDirectory;
  final VoidCallback onChange;
  final VoidCallback isGrid;
  final Widget body;
  final Widget? drawer;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool isSearching = false;
  List<FileSystemEntity> searchResults = [];
  String _selectedSort = 'default';

  @override
  void initState() {
    getItemSort();
    super.initState();
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching = false;
      return;
    }

    final results =
        await StorageSystem.searchItems(query, widget.currentDirectory ?? '');

    searchResults = results;
    isSearching = true;

    widget.onChange();
  }

  void getItemSort() async {
    String order = await UserSortPref.getSortOrder();
    setState(() => _selectedSort = order);
  }

  void setItemSort(String order) {
    setState(() => _selectedSort = order);
    UserSortPref.setSortOrder(order);
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search for note...',
                  border: InputBorder.none,
                ),
                onChanged: performSearch,
              )
            : Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              isSearching = !isSearching;
              setState(() {
                if (!isSearching) {
                  searchResults.clear();
                }
              });
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            onSelected: setItemSort,
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'default',
                checked: _selectedSort == 'default',
                child: const Text('Default Order'),
              ),
              CheckedPopupMenuItem(
                value: 'titleAsc',
                checked: _selectedSort == 'titleAsc',
                child: const Text('Title (Ascending)'),
              ),
              CheckedPopupMenuItem(
                value: 'titleDsc',
                checked: _selectedSort == 'titleDsc',
                child: const Text('Title (Descending)'),
              ),
              CheckedPopupMenuItem(
                value: 'lastModAsc',
                checked: _selectedSort == 'lastModAsc',
                child: const Text('Last Modified (Ascending)'),
              ),
              CheckedPopupMenuItem(
                value: 'lastModDsc',
                checked: _selectedSort == 'lastModDsc',
                child: const Text('Last Modified (Descending)'),
              ),
            ],
          ),
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'layoutSwitch') {
                String currentLayout = await UserLayoutPref.getLayoutView();
                setState(() {
                  if (currentLayout == 'grid') {
                    UserLayoutPref.setLayoutView('list');
                  } else {
                    UserLayoutPref.setLayoutView('grid');
                  }
                  widget.isGrid();
                });
              }
            },
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'layoutSwitch',
                child: ListTile(
                    leading: Icon(Icons.grid_view),
                    title: Text("Switch Layout")),
              ),
            ],
          ),
        ],
      ),
      drawer: widget.drawer,
      body: isSearching
          ? buildSearchResults(searchResults, widget.currentDirectory)
          : widget.body,
    );
  }
}
