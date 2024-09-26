import 'dart:io';

import 'package:flutter/material.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/configs/user_layout.dart';
import 'package:printnotes/utils/configs/user_sort.dart';
import 'package:printnotes/view/components/widgets/search.dart';

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

  void sortItems(String order) {
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
            onSelected: sortItems,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'default',
                child: Text('Default Order'),
              ),
              PopupMenuItem(
                value: 'titleAsc',
                child: Text('Title (Ascending)'),
              ),
              PopupMenuItem(
                value: 'titleDsc',
                child: Text('Title (Descending)'),
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
                child: Text("Switch Layout"),
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
