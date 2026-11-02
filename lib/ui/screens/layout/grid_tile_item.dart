import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:printnotes/markdown/markdown_widget/markdown_widget.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/customization_provider.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/style_handler.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/utils/parsers/frontmatter_parser.dart';
import 'package:printnotes/utils/parsers/hex_color_extension.dart';

import 'package:printnotes/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

class PreviewData {
  const PreviewData({
    this.fmTitle,
    this.fmDescription,
    this.previewText = '',
  });

  final String? fmTitle;
  final String? fmDescription;
  final String previewText;
}

class GridTileItem extends StatelessWidget {
  const GridTileItem(
      {super.key, required this.item, required this.previewCache});

  final FileSystemEntity item;
  final Map<String, Future<PreviewData>> previewCache;

  @override
  Widget build(BuildContext context) {
    final isDirectory = item is Directory;
    final isSelected =
        context.read<SelectingProvider>().selectedItems.contains(item.path);
    final useFM = context.read<SettingsProvider>().useFrontmatter;
    String? fmColor;
    String? fmBgColor;

    if (useFM && item.path.endsWith('.md')) {
      fmColor = FrontmatterHandleParsing.getTagString(
          File(item.path).readAsStringSync(), 'color');
      fmBgColor = FrontmatterHandleParsing.getTagString(
          File(item.path).readAsStringSync(), 'background');
    }

    return GestureDetector(
      onTap: () {
        if (context.read<SelectingProvider>().selectingMode) {
          if (!isDirectory) {
            context.read<SelectingProvider>().updateSelectedList(item);
          }
        } else {
          if (isDirectory) {
            context.read<NavigationProvider>().addToRouteHistory(item.path);
            context.read<SettingsProvider>().loadItems(item.path);
          } else if (item is File) {
            context
                .read<NavigationProvider>()
                .routeItemToPage(context, item.uri);
          }
        }
      },
      onLongPress: () => showBottomMenu(context, item),
      child: AbsorbPointer(
        child: Card(
          color:
              (isDirectory && context.watch<SelectingProvider>().selectingMode)
                  ? Theme.of(context).disabledColor.withValues(alpha: 0.1)
                  : (fmBgColor != null
                          ? HexColor.fromHex(fmBgColor)
                          : Theme.of(context).colorScheme.surfaceContainer)
                      ?.withValues(
                          alpha: context
                              .watch<CustomizationProvider>()
                              .noteTileOpacity),
          shape: isSelected
              ? StyleHandler.getNoteTileShape(
                  context.watch<CustomizationProvider>().noteTileShape,
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 5),
                  borderRadius: BorderRadius.circular(12))
              : StyleHandler.getNoteTileShape(
                  context.watch<CustomizationProvider>().noteTileShape),
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
                  padding: EdgeInsets.all(
                      context.watch<CustomizationProvider>().noteTilePadding),
                  child: _buildFileContent(
                    context,
                    fmColor != null ? HexColor.fromHex(fmColor) : null,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFileContent(BuildContext context, Color? color) {
    final entity = item;
    if (entity is File) {
      final type = fileTypeChecker(entity.path);
      final itemName = path.basename(entity.path);

      if (type == CFileType.image) {
        return Image.file(entity);
      } else if (type == CFileType.pdf) {
        return ListTile(
          leading: Icon(
            Icons.picture_as_pdf,
            size: 34,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            itemName,
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else if (type == CFileType.sketch) {
        return ListTile(
          leading: const Icon(Icons.draw, size: 34),
          title: Text(
            itemName.replaceAll('.bson', ''),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    }

    return FutureBuilder<PreviewData>(
      future: previewCache[item.path] ??= _loadPreviewData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (snapshot.hasError || data == null) {
          return const SizedBox();
        }
        return _buildPreview(context, data, color);
      },
    );
  }

  Future<PreviewData> _loadPreviewData(BuildContext context) async {
    final useFM = context.read<SettingsProvider>().useFrontmatter;
    final storage = StorageSystem(context); // created once before any await

    String? fmTitle;
    String? fmDescription;

    if (useFM) {
      final String fileText =
          await storage.getFilePreview(item.uri, isTrimmed: false);
      if (fileText != 'No preview available') {
        fmTitle = FrontmatterHandleParsing.getTagString(fileText, 'title');
        fmDescription =
            FrontmatterHandleParsing.getTagString(fileText, 'description');
      }
    }

    final String previewText =
        await storage.getFilePreview(item.uri, parseFrontmatter: useFM);

    return PreviewData(
      fmTitle: fmTitle,
      fmDescription: fmDescription,
      previewText: previewText,
    );
  }

  Widget _buildPreview(BuildContext context, PreviewData data, Color? color) {
    final itemName = path.basename(item.path);
    final markdownConfigs = theMarkdownConfigs(context,
        fileUri: item.uri, hideCodeButtons: true, textColor: color);
    final markdownGenerators = theMarkdownGenerators(context, textScale: 0.95);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.fmTitle ?? itemName.replaceAll(".md", ''),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        data.fmDescription != null
            ? Text(
                data.fmDescription!,
                style: TextStyle(color: color),
              )
            : MarkdownBlock(
                selectable: false,
                data: data.previewText,
                config: markdownConfigs,
                generator: markdownGenerators,
              ),
      ],
    );
  }
}
