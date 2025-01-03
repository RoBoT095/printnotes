import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';

import 'package:printnotes/ui/components/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

class GridListView extends StatelessWidget {
  const GridListView({
    super.key,
    required this.items,
    required this.onChange,
    required this.currentPath,
    required this.currentLayout,
    required this.latexSupport,
    required this.notePreviewLength,
  });

  final List<FileSystemEntity> items;
  final ValueSetter<String> onChange;
  final String currentPath;
  final String currentLayout;
  final bool latexSupport;
  final int notePreviewLength;

  Widget _buildGridItem(BuildContext context, int index) {
    final item = items[index];
    final isDirectory = item is Directory;

    return GestureDetector(
      onTap: () {
        if (isDirectory) {
          onChange(item.path);
          ItemNavHandler.addToFolderHistory(item.path);
        } else if (item is File) {
          ItemNavHandler.routeItemToPage(
              context, item, () => onChange(currentPath));
        }
      },
      onLongPress: () =>
          showBottomMenu(context, item, () => onChange(currentPath)),
      child: AbsorbPointer(
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: isDirectory
              ? ListTile(
                  leading: Icon(
                    Icons.folder,
                    size: 34,
                    color: Theme.of(context).colorScheme.secondary,
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
              previewLength: notePreviewLength),
          config: theMarkdownConfigs(context, hideCodeButtons: true),
          generator: theMarkdownGenerators(context,
              textScale: 0.95, useLatex: latexSupport),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: _displayGridCount(context, currentLayout),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childCount: items.length,
            itemBuilder: (context, index) => _buildGridItem(context, index),
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
