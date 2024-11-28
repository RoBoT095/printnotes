import 'package:flutter/material.dart';

import 'package:printnotes/utils/configs/user_preference.dart';
import 'package:printnotes/ui/components/search_view.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
    required this.title,
    required this.currentDirectory,
    required this.onChange,
    required this.layoutChange,
    required this.body,
    this.drawer,
  });

  final String title;
  final String currentDirectory;
  final VoidCallback onChange;
  final ValueSetter layoutChange;
  final Widget body;
  final Widget? drawer;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  bool isAdvancedSearch = false;
  String _selectedSort = 'default';
  String _currentLayout = 'grid';

  @override
  void initState() {
    getItemSort();
    getLayout();
    super.initState();
  }

  void getItemSort() async {
    String order = await UserSortPref.getSortOrder();
    setState(() => _selectedSort = order);
  }

  void setItemSort(String order) {
    setState(() => _selectedSort = order);
    UserSortPref.setSortOrder(order);
    widget.onChange();
    Navigator.of(context).pop();
  }

  void getLayout() async {
    String layout = await UserLayoutPref.getLayoutView();
    setState(() => _currentLayout = layout);
  }

  void setLayout(String layout) {
    setState(() => _currentLayout = layout);
    UserLayoutPref.setLayoutView(layout);
    widget.layoutChange(layout);
    widget.onChange();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: isAdvancedSearch
                      ? 'Advanced Search for notes...'
                      : 'Search for notes...',
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
              isSearching = !isSearching;
              setState(() {
                if (!isSearching) searchController.clear();
              });
            },
          ),
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() => isAdvancedSearch = !isAdvancedSearch);
                  },
                  icon: Icon(
                    isAdvancedSearch
                        ? Icons.filter_alt_outlined
                        : Icons.filter_alt_off_outlined,
                  ),
                )
              : PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: PopupMenuButton(
                        onSelected: setLayout,
                        itemBuilder: (context) => [
                          CheckedPopupMenuItem(
                            value: 'grid',
                            checked: _currentLayout == 'grid',
                            child: const Text('Grid View'),
                          ),
                          CheckedPopupMenuItem(
                            value: 'list',
                            checked: _currentLayout == 'list',
                            child: const Text('List View'),
                          ),
                          CheckedPopupMenuItem(
                            value: 'tree',
                            checked: _currentLayout == 'tree',
                            child: const Text('Tree View'),
                          ),
                        ],
                        child: const ListTile(
                            leading: Icon(Icons.grid_view),
                            title: Text("Change Layout")),
                      ),
                    ),
                    PopupMenuItem(
                      child: PopupMenuButton(
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
                            child: const Text('Title (Asc)'),
                          ),
                          CheckedPopupMenuItem(
                            value: 'titleDsc',
                            checked: _selectedSort == 'titleDsc',
                            child: const Text('Title (Desc)'),
                          ),
                          CheckedPopupMenuItem(
                            value: 'lastModAsc',
                            checked: _selectedSort == 'lastModAsc',
                            child: const Text('Last Mod (Asc)'),
                          ),
                          CheckedPopupMenuItem(
                            value: 'lastModDsc',
                            checked: _selectedSort == 'lastModDsc',
                            child: const Text('Last Mod (Desc)'),
                          ),
                        ],
                        child: const ListTile(
                          leading: Icon(Icons.sort),
                          title: Text('Sort By'),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
      drawer: widget.drawer,
      body: isSearching
          ? SearchView(
              searchQuery: searchController.text,
              currentDir: widget.currentDirectory,
              advancedSearch: isAdvancedSearch)
          : widget.body,
    );
  }
}
