import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';

import 'package:printnotes/constants/constants.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_navigation.dart';
import 'package:printnotes/ui/components/dialogs/bottom_menu_popup.dart';

// Good luck to future me to understanding all this again if I need to change something later

class TreeLayoutView extends StatelessWidget {
  const TreeLayoutView(
      {super.key, required this.initDir, required this.onChange});

  final String initDir;
  final VoidCallback onChange;

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
                  type: allowedImageExtensions
                          .any((ext) => item.path.endsWith(ext))
                      ? Image
                      : File))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TreeView.simpleTyped<Explorable, TreeNode<Explorable>>(
        tree: TreeNode.root(data: TFolder(initDir.split('/').last, initDir))
          ..addAll(getTree(initDir)),
        expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
        expansionIndicatorBuilder: (context, node) {
          return ChevronIndicator.rightDown(
            tree: node,
            alignment: Alignment.centerLeft,
            color: Colors.grey[700],
          );
        },
        indentation: const Indentation(),
        builder: (context, node) => Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: node is FileNode
                ? () {
                    if (node.data!.type == File) {
                      ItemNavHandler.onNoteSelect(
                          context, File(node.data!.path), () {});
                    } else if (node.data!.type == Image) {
                      ItemNavHandler.onImageSelect(
                          context, File(node.data!.path));
                    }
                  }
                : null,
            onLongPress: () => showBottomMenu(
              context,
              node is FileNode
                  ? File(node.data!.path)
                  : Directory(node.data!.path),
              onChange,
            ),
            child: ListTile(
              title: Text(node.data?.name ?? 'N/A'),
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: node.icon(context),
              ),
            ),
          ),
        ),
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
      if (file.type == Image) return const Icon(Icons.image_outlined);
    }

    return Icon(
      Icons.sticky_note_2_outlined,
      color: Theme.of(context).colorScheme.onError,
    );
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
