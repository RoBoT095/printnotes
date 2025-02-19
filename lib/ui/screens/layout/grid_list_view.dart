import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';

import 'package:printnotes/ui/components/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

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
  Widget _buildItem(BuildContext context, int index) {
    final item = widget.items[index];
    final isDirectory = item is Directory;
    final isSelected =
        context.read<SelectingProvider>().selectedItems.contains(item.path);

    return GestureDetector(
      onTap: () {
        if (context.read<SelectingProvider>().selectingMode) {
          if (!isDirectory) {
            context.read<SelectingProvider>().updateSelectedList(item);
          }
        } else {
          if (isDirectory) {
            context.read<NavigationProvider>().addToRouteHistory(item.path);
            widget.onChange();
          } else if (item is File) {
            context.read<NavigationProvider>().routeItemToPage(context, item);
          }
        }
      },
      onLongPress: () => showBottomMenu(context, item, widget.onChange),
      child: AbsorbPointer(
        child: Card(
          color:
              (isDirectory && context.watch<SelectingProvider>().selectingMode)
                  ? Theme.of(context).disabledColor.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surfaceContainer,
          shape: isSelected
              ? RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 5),
                  borderRadius: BorderRadius.circular(12))
              : null,
          child: isDirectory
              ? ListTile(
                  leading: Icon(
                    Icons.folder,
                    size: 34,
                    color: context.watch<SelectingProvider>().selectingMode
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    path.basename(item.path),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: fileItem(context, item)),
        ),
      ),
    );
  }

  Widget fileItem(BuildContext context, FileSystemEntity item) {
    if (item is File) {
      if (fileTypeChecker(item) == CFileType.image) {
        return Image.file(item);
      }
      if (fileTypeChecker(item) == CFileType.pdf) {
        return ListTile(
          leading: Icon(
            Icons.picture_as_pdf,
            size: 34,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            path.basename(item.path),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          path.basename(item.path).replaceAll(".md", ''),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        MarkdownBlock(
          selectable: false,
          data: StorageSystem.getFilePreview(item.path,
              previewLength: context.watch<SettingsProvider>().previewLength),
          config: theMarkdownConfigs(context, hideCodeButtons: true),
          generator: theMarkdownGenerators(context, textScale: 0.95),
        ),
      ],
    );
  }

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
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childCount: widget.items.length,
            itemBuilder: (context, index) => _buildItem(context, index),
          ),
        ),
        // Adds empty space at bottom, helps when in list view
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
          ),
        )
      ],
    );
  }

  int _displayGridCount(BuildContext context, String layout) {
    if (layout == 'list') {
      return 1;
    } else {
      double displayWidth = MediaQuery.sizeOf(context).width;
      if (displayWidth > 1200) {
        return 4;
      } else {
        return 2;
      }
    }
  }
}
