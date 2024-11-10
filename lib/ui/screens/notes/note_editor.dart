import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:printnotes/utils/handlers/item_rename.dart';
import 'package:printnotes/ui/components/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/markdown/editor_field.dart';
import 'package:printnotes/ui/components/markdown/toolbar/markdown_toolbar.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen(
      {super.key, required this.filePath, this.latexSupport});

  final String filePath;
  final bool? latexSupport;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

// For switching between preview and edit with ctrl-shift-v
class SwitchModeIntent extends Intent {
  const SwitchModeIntent();
}

bool isScreenLarge(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= 1000;
}

bool isMobile() {
  return !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS;
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  final TocController _tocController = TocController();
  final FocusNode _focusNode = FocusNode();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isEditingName = false;
  bool _isEditingNote = false;
  bool _isLoading = true;
  String fileTitle = '';

  @override
  void initState() {
    _titleController = TextEditingController();
    _notesController = TextEditingController();
    _loadNoteContent();
    super.initState();
  }

  Future<bool> _openExplorer() async {
    final file = File(widget.filePath);
    final path = file.parent.path;
    if (Platform.isLinux) {
      Process.run("xdg-open", [path], workingDirectory: path);
    }
    if (Platform.isWindows) {
      Process.run("explorer", [path], workingDirectory: path);
    }
    if (Platform.isMacOS) {
      Process.run("open", [path], workingDirectory: path);
    }

    if (isMobile()) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('Currently not supported on mobile', durationMil: 3000),
      );
    }

    return true;
  }

  Future<void> _loadNoteContent() async {
    try {
      final file = File(widget.filePath);
      final content = await file.readAsString();

      setState(() {
        fileTitle = widget.filePath.split('/').last;
        _titleController.text = fileTitle.replaceFirst('.md', '');
        _notesController.text = content;
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

  Future<bool> _saveNoteContent(BuildContext context) async {
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_notesController.text);
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

  @override
  Widget build(BuildContext context) {
    Color mobileNullColor = !isMobile()
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.5);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final canPop = await _saveNoteContent(context);
        if (canPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        appBar: AppBar(
          title: GestureDetector(
            onDoubleTap: () => setState(() => _isEditingName = true),
            child: _isEditingName
                ? TextField(
                    controller: _titleController,
                    onSubmitted: (value) => _saveTitleRename(context, value))
                : Tooltip(
                    preferBelow: true,
                    message: 'Double tap title to rename it',
                    child: Text(fileTitle)),
          ),
          actions: [
            IconButton(
                tooltip: 'Preview/Edit Mode',
                icon: Icon(_isEditingNote ? Icons.visibility : Icons.mode_edit),
                onPressed: () {
                  setState(() => _isEditingNote = !_isEditingNote);
                }),
            if (isScreenLarge(context) && _notesController.text.contains("# "))
              IconButton(
                tooltip: 'Table of Contents',
                onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                icon: const Icon(Icons.toc_rounded),
              ),
            PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.folder_open),
                    title: const Text("Open Note Location"),
                    iconColor: mobileNullColor,
                    textColor: mobileNullColor,
                  ),
                  onTap: () async => await _openExplorer(),
                ),
              ],
            ),
          ],
        ),
        body: buildMarkdownView(),
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Table of Contents',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(
                  thickness: 0.3,
                ),
                Expanded(
                  child: _notesController.text.contains("# ")
                      ? buildTocList()
                      : const Center(
                          child: Text(
                            'Add headers using "#" to populate\n the table of contents',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
            !isScreenLarge(context) && _notesController.text.contains("# ")
                ? FloatingActionButton(
                    onPressed: _scaffoldKey.currentState!.openEndDrawer,
                    heroTag: 'Table of Contents',
                    child: const Icon(Icons.format_list_bulleted),
                  )
                : null,
      ),
    );
  }

  Widget buildTocList() => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20)),
      child: TocWidget(controller: _tocController));

  Widget buildMarkdownView() {
    return SafeArea(
      child: Container(
        margin: isScreenLarge(context)
            ? EdgeInsets.symmetric(
                horizontal: (MediaQuery.sizeOf(context).width - 1000) / 2,
                vertical: 15)
            : null,
        width: 1000,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: FooterLayout(
          footer: _isEditingNote
              ? MarkdownToolbar(
                  controller: _notesController,
                  onValueChange: (value) async =>
                      await _saveNoteContent(context),
                  onPreviewChanged: () {
                    setState(() => _isEditingNote = !_isEditingNote);
                  },
                  undoController: _undoHistoryController,
                  toolbarBackground:
                      Theme.of(context).colorScheme.surfaceContainer,
                )
              : null,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Shortcuts(
                  shortcuts: <ShortcutActivator, Intent>{
                    LogicalKeySet(
                        LogicalKeyboardKey.control,
                        LogicalKeyboardKey.shift,
                        LogicalKeyboardKey.keyV): const SwitchModeIntent(),
                  },
                  child: Actions(
                    actions: <Type, Action<Intent>>{
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
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: _isEditingNote
                            ? EditorField(
                                controller: _notesController,
                                onChanged: (value) async =>
                                    await _saveNoteContent(context),
                                undoController: _undoHistoryController,
                              )
                            : GestureDetector(
                                onDoubleTap: () {
                                  setState(
                                      () => _isEditingNote = !_isEditingNote);
                                },
                                child: _notesController.text.isEmpty
                                    ? SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height,
                                        child: Text(
                                          'Double click screen or hit the pencil icon in the top right corner to write!',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                      )
                                    : buildMarkdownWidget(
                                        context,
                                        data: _notesController.text,
                                        tocController: _tocController,
                                        latexSupport: widget.latexSupport,
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
    _titleController.dispose();
    _notesController.dispose();
    _focusNode.dispose();
    _tocController.dispose();
    super.dispose();
  }
}
