import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:printnotes/utils/storage_system.dart';

class SelectLocationDialog extends StatefulWidget {
  const SelectLocationDialog({
    super.key,
    required this.baseDir,
    required this.currentItem,
  });

  final String baseDir;
  final FileSystemEntity currentItem;

  @override
  State<SelectLocationDialog> createState() => _SelectLocationDialogState();
}

class _SelectLocationDialogState extends State<SelectLocationDialog> {
  late String _currentDir;
  List<FileSystemEntity> _directories = [];

  @override
  void initState() {
    super.initState();
    _currentDir = widget.baseDir;
    _loadDirectories();
  }

  void _loadDirectories() {
    final contents = StorageSystem.listFolderContents(_currentDir);
    setState(() {
      _directories = contents.whereType<Directory>().toList();
      // Removes the current item if it's a directory to prevent moving into itself
      if (widget.currentItem is Directory) {
        _directories.removeWhere((dir) => dir.path == widget.currentItem.path);
      }
    });
  }

  void _navigateUp() {
    if (_currentDir != widget.baseDir) {
      setState(() {
        _currentDir = path.dirname(_currentDir);
        _loadDirectories();
      });
    }
  }

  void _navigateInto(Directory dir) {
    setState(() {
      _currentDir = dir.path;
      _loadDirectories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select destination'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // When entering a folder, shows '../folder_name' button to return
            if (_currentDir != widget.baseDir)
              ListTile(
                leading: const Icon(Icons.arrow_back),
                title: Text('../${path.basename(_currentDir)}'),
                onTap: _navigateUp,
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _directories.length,
                itemBuilder: (context, index) {
                  final dir = _directories[index];
                  return ListTile(
                    leading: Icon(
                      Icons.folder,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(path.basename(dir.path)),
                    onTap: () => _navigateInto(dir as Directory),
                  );
                },
              ),
            ),
            // If no folders in directory, show message
            if (_directories.isEmpty)
              const Expanded(
                child: Text(
                    'No folders here to move into, maybe create one first?'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Move here'),
          onPressed: () => Navigator.of(context).pop(_currentDir),
        ),
      ],
    );
  }
}
