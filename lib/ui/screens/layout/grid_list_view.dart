import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printnotes/ui/screens/layout/grid_tile_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/customization_provider.dart';

class GridListView extends StatefulWidget {
  const GridListView({
    super.key,
    required this.items,
    required this.onChange,
  });

  final List<FileSystemEntity> items;
  final VoidCallback onChange;

  @override
  State<GridListView> createState() => _GridListViewState();
}

class _GridListViewState extends State<GridListView> {
  @override
  Widget build(BuildContext context) {
    if (!context.watch<SelectingProvider>().selectingMode) {
      context.read<SelectingProvider>().selectedItems.clear();
    }
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: _displayGridCount(
                context, context.watch<SettingsProvider>().layout),
            mainAxisSpacing:
                context.watch<CustomizationProvider>().noteTileSpacing,
            crossAxisSpacing:
                context.watch<CustomizationProvider>().noteTileSpacing,
            childCount: widget.items.length,
            itemBuilder: (context, index) => GridTileItem(
                item: widget.items[index], onChange: widget.onChange),
          ),
        ),
        // Adds empty space at bottom, helps when in list view
        const SliverToBoxAdapter(child: SizedBox(height: 200))
      ],
    );
  }

  int _displayGridCount(BuildContext context, String layout) {
    double displayWidth = MediaQuery.sizeOf(context).width;
    return layout == 'list'
        ? 1
        : displayWidth > 1200
            ? 4
            : 2;
  }
}
