import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';

import 'package:printnotes/ui/components/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

class GridListView extends StatefulWidget {
  const GridListView({
    super.key,
    required this.items,
    required this.onChange,
    required this.isSelecting,
    required this.selectedItems,
  });

  final List<FileSystemEntity> items;
  final ValueSetter<String> onChange;
  final bool isSelecting;
  final Set<dynamic> selectedItems;

  @override
  State<GridListView> createState() => _GridListViewState();
}

class _GridListViewState extends State<GridListView> {
  Widget _buildItem(BuildContext context, int index) {
    final item = widget.items[index];
    final isDirectory = item is Directory;
    final isSelected = widget.selectedItems.contains(item);

    return GestureDetector(
      onTap: () {
        if (widget.isSelecting) {
          if (!isDirectory) {
            if (isSelected) {
              setState(() => widget.selectedItems.remove(item));
            } else {
              setState(() => widget.selectedItems.add(item));
            }
          }
        } else {
          if (isDirectory) {
            widget.onChange(item.path);
            ItemNavHandler.addToFolderHistory(item.path);
          } else if (item is File) {
            ItemNavHandler.routeItemToPage(
                context,
                item,
                () =>
                    widget.onChange(context.read<SettingsProvider>().mainDir));
          }
        }
      },
      onLongPress: () => showBottomMenu(context, item,
          () => widget.onChange(context.read<SettingsProvider>().mainDir)),
      child: AbsorbPointer(
        child: Card(
          color: (isDirectory && widget.isSelecting)
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
                    color: widget.isSelecting
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

  Widget fileItem(BuildContext context, item) {
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
          data: StorageSystem.getNotePreview(item.path,
              previewLength: context.watch<SettingsProvider>().previewLength),
          config: theMarkdownConfigs(context, hideCodeButtons: true),
          generator: theMarkdownGenerators(context, textScale: 0.95),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelecting == false) widget.selectedItems.clear();
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
