import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';

import 'package:printnotes/ui/components/search_view.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
  });

  final String title;
  final Widget body;
  final Widget? drawer;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String currentFolderPriority =
        context.watch<SettingsProvider>().folderPriority;
    String currentSort = context.watch<SettingsProvider>().sortOrder;
    String currentLayout = context.watch<SettingsProvider>().layout;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        leading: isSearching
            ? Icon(Icons.menu, color: Theme.of(context).disabledColor)
            : null,
        centerTitle: false,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search for notes...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() => searchController.text = query);
                },
              )
            : Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Search Notes',
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              context.read<SelectingProvider>().setSelectingMode(mode: false);
              isSearching = !isSearching;
              setState(() {
                if (!isSearching) searchController.clear();
              });
            },
          ),
          PopupMenuButton(
            tooltip: 'More',
            icon: const Icon(Icons.more_vert),
            enabled: !isSearching,
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: PopupMenuButton(
                  onSelected: (value) {
                    context.read<SettingsProvider>().setLayout(value);
                    context
                        .read<SelectingProvider>()
                        .setSelectingMode(mode: false);
                    Navigator.pop(context);
                  },
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: 'grid',
                      checked: currentLayout == 'grid',
                      child: const Text('Grid View'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'list',
                      checked: currentLayout == 'list',
                      child: const Text('List View'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'tree',
                      checked: currentLayout == 'tree',
                      child: const Text('Tree View'),
                    ),
                  ],
                  child: const ListTile(
                      leading: Icon(Icons.grid_view),
                      title: Text("Change Layout")),
                ),
              ),
              PopupMenuItem(
                enabled: !context.read<SelectingProvider>().selectingMode,
                child: PopupMenuButton(
                  onSelected: (value) {
                    context.read<SettingsProvider>().setSortOrder(value);
                    Navigator.pop(context);
                  },
                  enabled: !context.read<SelectingProvider>().selectingMode,
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: 'default',
                      checked: currentSort == 'default',
                      child: const Text('Default Order'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'titleAsc',
                      checked: currentSort == 'titleAsc',
                      child: const Text('Title (Asc)'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'titleDsc',
                      checked: currentSort == 'titleDsc',
                      child: const Text('Title (Desc)'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'lastModAsc',
                      checked: currentSort == 'lastModAsc',
                      child: const Text('Last Mod (Asc)'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'lastModDsc',
                      checked: currentSort == 'lastModDsc',
                      child: const Text('Last Mod (Desc)'),
                    ),
                  ],
                  child: const ListTile(
                    leading: Icon(Icons.sort),
                    title: Text('Sort By'),
                  ),
                ),
              ),
              PopupMenuItem(
                enabled: !context.read<SelectingProvider>().selectingMode,
                child: PopupMenuButton(
                  onSelected: (value) {
                    context.read<SettingsProvider>().setFolderPriority(value);
                    Navigator.pop(context);
                  },
                  enabled: !context.read<SelectingProvider>().selectingMode,
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: 'above',
                      checked: currentFolderPriority == 'above',
                      child: const Text('Above'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'none',
                      checked: currentFolderPriority == 'none',
                      child: const Text('None'),
                    ),
                    CheckedPopupMenuItem(
                      value: 'below',
                      checked: currentFolderPriority == 'below',
                      child: const Text('Below'),
                    )
                  ],
                  child: const ListTile(
                    leading: Icon(Icons.folder_copy_outlined),
                    title: Text('Folder Priority'),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      drawer: widget.drawer,
      body: isSearching
          ? SearchView(searchQuery: searchController.text)
          : widget.body,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
