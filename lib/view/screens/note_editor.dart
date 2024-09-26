import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:printnotes/utils/handlers/item_rename.dart';
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

bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= 800;
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  final TocController _tocController = TocController();
  final FocusNode _focusNode = FocusNode();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();

  bool _isEditingName = false;
  bool _isEditingNote = false;
  bool _isLoading = true;
  bool _isDirty = false;
  String fileTitle = '';
  String _originalContent = '';

  @override
  void initState() {
    _titleController = TextEditingController();
    _notesController = TextEditingController();
    _loadNoteContent();
    super.initState();
  }

  Future<void> _loadNoteContent() async {
    try {
      final file = File(widget.filePath);
      final content = await file.readAsString();
      setState(() {
        fileTitle = widget.filePath.split('/').last;
        _titleController.text = fileTitle.replaceFirst('.md', '');
        _notesController.text = content;
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

  Future<bool> _saveTitleRename(BuildContext context, String newTitle) async {
    try {
      await ItemRenameHandler.handleItemRename(
          context, File(widget.filePath), newTitle.replaceAll('.md', ''));
      setState(() {
        fileTitle = '$newTitle.md';
        _isEditingName = false;
      });
      return true;
    } catch (e) {
      debugPrint('Error renaming note title: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Error renaming note title'),
        );
      }
      return false;
    }
  }

  Future<bool> _saveNoteContent(BuildContext context,
      {bool quietSave = false}) async {
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_notesController.text);
      setState(() {
        _isDirty = false;
        _originalContent = _notesController.text;
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
          title: GestureDetector(
            onDoubleTap: () => setState(() => _isEditingName = true),
            child: _isEditingName
                ? TextField(
                    controller: _titleController,
                    onSubmitted: (value) => _saveTitleRename(context, value))
                : Text(fileTitle),
          ),
          actions: [
            IconButton(
                icon: Icon(_isEditingNote ? Icons.visibility : Icons.mode_edit),
                tooltip: 'Preview/Edit Mode',
                onPressed: () {
                  setState(() {
                    _isEditingNote = !_isEditingNote;
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
        body: buildMarkdownView(),
        floatingActionButton: _isEditingNote || isDesktop(context)
            ? null
            : FloatingActionButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (ctx) => _tocController.tocList.isEmpty
                      ? const Center(
                          child: Text(
                            'Table of Contents empty,\nUse headers to create ToC\nfor easier navigation!',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : buildTocList(),
                ),
                heroTag: 'Table of Contents List',
                child: const Icon(Icons.format_list_bulleted),
              ),
      ),
    );
  }

  Widget buildTocList() => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: TocWidget(controller: _tocController));

  Widget buildMarkdownView() {
    return SafeArea(
      child: FooterLayout(
        footer: _isEditingNote
            ? MarkdownToolbar(
                controller: _notesController,
                onValueChange: (value) {
                  setState(() => _isDirty = value);
                },
                onPreviewChanged: () {
                  setState(() => _isEditingNote = !_isEditingNote);
                },
                undoController: _undoHistoryController,
                toolbarBackground: Theme.of(context).colorScheme.surface)
            : null,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Shortcuts(
                shortcuts: <ShortcutActivator, Intent>{
                  LogicalKeySet(
                          LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
                      const SaveIntent(),
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
                        _isEditingNote = !_isEditingNote;
                      }),
                    ),
                  },
                  child: Focus(
                    autofocus: true,
                    focusNode: _focusNode,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _isEditingNote
                          ? EditorField(
                              controller: _notesController,
                              onChanged: (value) {
                                setState(() {
                                  _isDirty = value != _originalContent ||
                                      _notesController.text != _originalContent;
                                });
                              },
                              undoController: _undoHistoryController,
                            )
                          : GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  _isEditingNote = !_isEditingNote;
                                });
                              },
                              child: _notesController.text.isEmpty
                                  ? SizedBox(
                                      height: MediaQuery.sizeOf(context).height,
                                      child: Text(
                                        'Double click screen or hit the pencil icon in the top right corner to write!',
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor),
                                      ),
                                    )
                                  : isDesktop(context) &&
                                          _notesController.text.contains('# ')
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
                                              child: buildMarkdownWidget(
                                                context,
                                                data: _notesController.text,
                                                tocController: _tocController,
                                              ),
                                            ),
                                            Expanded(child: buildTocList())
                                          ],
                                        )
                                      : buildMarkdownWidget(
                                          context,
                                          data: _notesController.text,
                                          tocController: _tocController,
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
    _titleController.dispose();
    _notesController.dispose();
    _focusNode.dispose();
    _tocController.dispose();
    super.dispose();
  }
}
