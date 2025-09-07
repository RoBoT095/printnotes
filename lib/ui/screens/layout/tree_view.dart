import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:animated_tree_view/animated_tree_view.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/customization_provider.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/utils/handlers/item_sort.dart';
import 'package:printnotes/utils/parsers/frontmatter_parser.dart';

import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

// Good luck to future me to understanding all this again if I need to change something later

class TreeLayoutView extends StatefulWidget {
  const TreeLayoutView({
    super.key,
    required this.onChange,
  });

  final VoidCallback onChange;

  @override
  State<TreeLayoutView> createState() => _TreeLayoutViewState();
}

class _TreeLayoutViewState extends State<TreeLayoutView> {
  late TreeNode<Explorable> _rootNode;

  @override
  void initState() {
    super.initState();
    _loadTree();
  }

  Future<void> _loadTree() async {
    String mainDir = context.read<SettingsProvider>().mainDir;

    _rootNode = TreeNode.root(
        data: TFolder(mainDir.split(path.separator).last, mainDir));
    _rootNode.addAll(await getTree(mainDir));
  }

  Future<List<Node>> getTree(String dir) async {
    List<FileSystemEntity> items = await StorageSystem.listFolderContents(dir);
    items = ItemSortHandler.getSortedItems(
      items,
      context.read<SettingsProvider>().folderPriority,
      context.read<SettingsProvider>().sortOrder,
    );
    bool useFM = context.read<SettingsProvider>().useFrontmatter;

    String getFileName(String filePath) {
      if (filePath.endsWith('.md')) {
        if (useFM) {
          String? title = FrontmatterHandleParsing.getTagString(
              File(filePath).readAsStringSync(), 'title');
          if (title != null) return title;
        }
        return path.basename(filePath).replaceAll('.md', '');
      }
      if (path.extension(filePath) == '.bson') {
        return path.basename(filePath).replaceAll('.bson', '');
      }
      return path.basename(filePath);
    }

    return [
      for (FileSystemEntity item in items)
        if (item is Directory)
          FolderNode(data: TFolder(path.basename(item.path), item.path))
            ..addAll(await getTree(item.path))
        else if (item is File)
          FileNode(data: TFile(getFileName(item.path), item.path, type: File))
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<SelectingProvider>().selectingMode) {
      context.read<SelectingProvider>().selectedItems.clear();
    }

    return SafeArea(
      child: TreeView.simpleTyped<Explorable, TreeNode<Explorable>>(
        tree: _rootNode,
        expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
        expansionIndicatorBuilder: (context, node) {
          return ChevronIndicator.rightDown(
            tree: node,
            alignment: Alignment.centerLeft,
            color: Colors.grey[700],
          );
        },
        showRootNode: false,
        indentation: const Indentation(),
        builder: (context, node) {
          return Container(
            color: Theme.of(context).colorScheme.surface.withValues(
                alpha: context.watch<CustomizationProvider>().noteTileOpacity),
            padding: const EdgeInsets.only(left: 16.0),
            child: GestureDetector(
              onTap: node is FileNode
                  ? () => context
                      .read<NavigationProvider>()
                      .routeItemToPage(context, File(node.data!.path))
                  : null,
              onLongPress: () => showBottomMenu(
                context,
                node is FileNode
                    ? File(node.data!.path)
                    : Directory(node.data!.path),
                widget.onChange,
              ),
              child: ListTile(
                title: Text(node.data?.name ?? 'N/A'),
                leading: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: node.icon(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on ExplorableNode {
  Icon icon(context) {
    if (isRoot) return const Icon(Icons.data_object);

    if (this is FolderNode) {
      if (isExpanded) {
        return Icon(
          Icons.folder_open,
          color: Theme.of(context).colorScheme.secondary,
        );
      }
      return Icon(
        Icons.folder,
        color: Theme.of(context).colorScheme.secondary,
      );
    }

    if (this is FileNode) {
      final file = data as TFile;
      if (fileTypeChecker(File(file.path)) == CFileType.image) {
        return Icon(Icons.image_outlined,
            color: Theme.of(context).colorScheme.primary);
      }
      if (fileTypeChecker(File(file.path)) == CFileType.pdf) {
        return const Icon(Icons.picture_as_pdf);
      }
      if (fileTypeChecker(File(file.path)) == CFileType.sketch) {
        return const Icon(Icons.draw);
      }
    }

    return const Icon(Icons.sticky_note_2_outlined);
  }
}

abstract class Explorable {
  final String name;
  final String path;

  Explorable(this.name, this.path);

  @override
  String toString() => name;
}

class TFile extends Explorable {
  final Type type;

  TFile(super.name, super.path, {required this.type});
}

class TFolder extends Explorable {
  TFolder(super.name, super.path);
}

typedef ExplorableNode = TreeNode<Explorable>;

typedef FileNode = TreeNode<TFile>;

typedef FolderNode = TreeNode<TFolder>;
