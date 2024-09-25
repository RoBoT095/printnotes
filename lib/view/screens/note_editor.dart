import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import 'package:printnotes/view/components/markdown/build_markdown.dart';
import 'package:printnotes/view/components/markdown/toolbar/markdown_toolbar.dart';
import 'package:printnotes/view/components/markdown/editor_field.dart';
import 'package:printnotes/view/components/widgets/custom_snackbar.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, required this.filePath});

  final String filePath;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

// For saving notes with ctrl-s
class SaveIntent extends Intent {
  const SaveIntent();
}

// For switching between preview and edit with ctrl-shift-v
class SwitchModeIntent extends Intent {
  const SwitchModeIntent();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isDirty = false;
  String _originalContent = '';

  @override
  void initState() {
    _controller = TextEditingController();
    _loadNoteContent();
    super.initState();
  }

  Future<void> _loadNoteContent() async {
    try {
      final file = File(widget.filePath);
      final content = await file.readAsString();
      setState(() {
        _controller.text = content;
        _originalContent = content;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading note content: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _saveNoteContent(BuildContext context,
      {bool quietSave = false}) async {
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_controller.text);
      setState(() {
        _isDirty = false;
        _originalContent = _controller.text;
      });
      if (context.mounted && quietSave == false) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          'Saved!',
          width: MediaQuery.sizeOf(context).width * 0.3,
          durationMil: 500,
        ));
      }
      return true;
    } catch (e) {
      debugPrint('Error saving note content: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Error saving note'),
        );
      }
      return false;
    }
  }

  Future<bool> _didYouSave() async {
    if (!_isDirty) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('Do you want to save your changes?'),
        actions: [
          TextButton(
            child: Text(
              'Discard',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () async {
              final saved = await _saveNoteContent(context);
              if (context.mounted) Navigator.of(context).pop(saved);
            },
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final canPop = await _didYouSave();
        if (canPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.filePath.split('/').last),
          actions: [
            IconButton(
                icon: Icon(_isEditing ? Icons.visibility : Icons.mode_edit),
                tooltip: 'Preview/Edit Mode',
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                }),
            IconButton(
              icon: Icon(
                Icons.save,
                color: _isDirty
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              tooltip: 'Save Note',
              onPressed: () async =>
                  _isDirty ? await _saveNoteContent(context) : null,
            ),
          ],
        ),
        body: SafeArea(
          child: FooterLayout(
            footer: _isEditing
                ? MarkdownToolbar(
                    controller: _controller,
                    onValueChange: (value) {
                      setState(() {
                        _isDirty = value;
                      });
                    },
                    onPreviewChanged: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    undoController: _undoHistoryController,
                    toolbarBackground: Theme.of(context).colorScheme.surface)
                : null,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Shortcuts(
                    shortcuts: <ShortcutActivator, Intent>{
                      LogicalKeySet(LogicalKeyboardKey.control,
                          LogicalKeyboardKey.keyS): const SaveIntent(),
                      LogicalKeySet(
                          LogicalKeyboardKey.control,
                          LogicalKeyboardKey.shift,
                          LogicalKeyboardKey.keyV): const SwitchModeIntent(),
                    },
                    child: Actions(
                      actions: <Type, Action<Intent>>{
                        SaveIntent: CallbackAction<SaveIntent>(
                          onInvoke: (SaveIntent intent) =>
                              _saveNoteContent(context),
                        ),
                        SwitchModeIntent: CallbackAction<SwitchModeIntent>(
                          onInvoke: (SwitchModeIntent intent) => setState(() {
                            _isEditing = !_isEditing;
                          }),
                        ),
                      },
                      child: Focus(
                        autofocus: true,
                        focusNode: _focusNode,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                _isEditing
                                    ? EditorField(
                                        controller: _controller,
                                        onChanged: (value) {
                                          setState(() {
                                            _isDirty =
                                                value != _originalContent ||
                                                    _controller.text !=
                                                        _originalContent;
                                          });
                                        },
                                        undoController: _undoHistoryController,
                                      )
                                    : GestureDetector(
                                        onDoubleTap: () {
                                          setState(() {
                                            _isEditing = !_isEditing;
                                          });
                                        },
                                        child: _controller.text.isEmpty
                                            ? Text(
                                                'Double click screen or hit the pencil icon in the top right corner to write!',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              )
                                            : buildMarkdownView(context,
                                                data: _controller.text)),
                                const SizedBox(
                                  height: 200,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
