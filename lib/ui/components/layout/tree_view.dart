import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';

import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/file_extensions.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

// Good luck to future me to understanding all this again if I need to change something later

class TreeLayoutView extends StatefulWidget {
  const TreeLayoutView({
    super.key,
    required this.initDir,
    required this.onChange,
    required this.isSelecting,
    required this.selectedItems,
  });

  final String initDir;
  final VoidCallback onChange;
  final bool isSelecting;
  final Set<dynamic> selectedItems;

  @override
  State<TreeLayoutView> createState() => _TreeLayoutViewState();
}

class _TreeLayoutViewState extends State<TreeLayoutView> {
  late TreeNode<Explorable> _rootNode;

  @override
  void initState() {
    super.initState();
    _buildTree();
  }

  void _buildTree() {
    _rootNode = TreeNode.root(
        data: TFolder(widget.initDir.split('/').last, widget.initDir));
    _rootNode.addAll(getTree(widget.initDir));
  }

  List<Node> getTree(String directory) {
    final List<FileSystemEntity> items =
        StorageSystem.listFolderContents(directory);

    return [
      for (var item in items)
        if (item is Directory)
          FolderNode(data: TFolder(item.path.split('/').last, item.path))
            ..addAll(getTree(item.path))
        else if (item is File)
          FileNode(
              data: TFile(item.path.split('/').last, item.path,
                  type:
                      fileTypeChecker(item) == CFileType.image ? Image : File))
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelecting == false) widget.selectedItems.clear();

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
          final isSelected = widget.selectedItems.contains(node);
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: GestureDetector(
              onTap: node is FileNode
                  ? () {
                      if (widget.isSelecting) {
                        if (isSelected) {
                          setState(() => widget.selectedItems.remove(node));
                        } else {
                          setState(() => widget.selectedItems.add(node));
                        }
                      } else {
                        ItemNavHandler.routeItemToPage(
                            context, File(node.data!.path), () {});
                      }
                    }
                  : null,
              onLongPress: () => showBottomMenu(
                context,
                node is FileNode
                    ? File(node.data!.path)
                    : Directory(node.data!.path),
                widget.onChange,
              ),
              child: ListTile(
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.onSecondary,
                selectedTileColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.8),
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
      if (file.type == Image) {
        return Icon(
          Icons.image_outlined,
          color: Theme.of(context).colorScheme.primary,
        );
      }
      if (fileTypeChecker(File(file.path)) == CFileType.pdf) {
        return const Icon(Icons.picture_as_pdf);
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
