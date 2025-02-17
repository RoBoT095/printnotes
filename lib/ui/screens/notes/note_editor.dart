import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import 'package:printnotes/providers/editor_config_provider.dart';
import 'package:printnotes/utils/open_explorer.dart';
import 'package:printnotes/ui/screens/notes/editor_config_screen.dart';
import 'package:printnotes/ui/components/markdown/build_markdown.dart';
import 'package:printnotes/ui/components/markdown/editor_field.dart';
import 'package:printnotes/ui/components/markdown/toolbar/markdown_toolbar.dart';
import 'package:printnotes/ui/widgets/file_info_bottom_sheet.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, required this.filePath});

  final String filePath;

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

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _notesController;
  final TocController _tocController = TocController();
  final FocusNode _focusNode = FocusNode();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isEditingFile = false;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    _notesController = TextEditingController();
    _loadFileContent();
    super.initState();
  }

  Future<void> _loadFileContent() async {
    try {
      final file = File(widget.filePath);
      final content = await file.readAsString();

      setState(() {
        _notesController.text = content;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading file content: $e');
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<bool> _saveFileContent(BuildContext context) async {
    if (_isError) return true;
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_notesController.text);
      return true;
    } catch (e) {
      debugPrint('Error saving file content: $e');
      if (context.mounted) {
        customSnackBar('Error saving file', type: 'error').show(context);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final canPop = await _saveFileContent(context);
        if (canPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        appBar: AppBar(
          title: Text(widget.filePath.split('/').last),
          actions: _isError
              ? null
              : [
                  IconButton(
                      tooltip: 'Preview/Edit Mode',
                      icon: Icon(
                          _isEditingFile ? Icons.visibility : Icons.mode_edit),
                      onPressed: () {
                        setState(() => _isEditingFile = !_isEditingFile);
                      }),
                  if (isScreenLarge(context) &&
                      _notesController.text.contains("# "))
                    IconButton(
                      tooltip: 'Table of Contents',
                      onPressed: () =>
                          _scaffoldKey.currentState!.openEndDrawer(),
                      icon: const Icon(Icons.toc_rounded),
                    ),
                  PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text('Info'),
                        ),
                        onTap: () =>
                            modalShowFileInfo(context, widget.filePath),
                      ),
                      PopupMenuItem(
                        child: const ListTile(
                          leading: Icon(Icons.tune),
                          title: Text('Configure'),
                        ),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditorConfigScreen())),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.folder_open),
                          title: const Text("Open Location"),
                          iconColor: mobileNullColor(context),
                          textColor: mobileNullColor(context),
                        ),
                        onTap: () async =>
                            await openExplorer(context, widget.filePath),
                      ),
                    ],
                  ),
                ],
        ),
        body: buildMarkdownView(),
        endDrawer: _isError
            ? null
            : Drawer(
                child: SafeArea(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Table of Contents',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
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
        floatingActionButton: !isScreenLarge(context) &&
                _notesController.text.contains("# ") &&
                !_isEditingFile
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
          borderRadius:
              isScreenLarge(context) ? BorderRadius.circular(10) : null,
        ),
        child: FooterLayout(
          footer: _isEditingFile
              ? MarkdownToolbar(
                  controller: _notesController,
                  onValueChange: (value) async =>
                      await _saveFileContent(context),
                  onPreviewChanged: () {
                    setState(() => _isEditingFile = !_isEditingFile);
                  },
                  undoController: _undoHistoryController,
                  toolbarBackground:
                      Theme.of(context).colorScheme.surfaceContainer,
                  expandableBackground: Theme.of(context).colorScheme.surface,
                  userToolbarItemList:
                      context.watch<EditorConfigProvider>().toolbarItemList,
                )
              : null,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isError
                  ? const Center(child: Text('Error Reading File'))
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
                              _isEditingFile = !_isEditingFile;
                            }),
                          ),
                        },
                        child: Focus(
                          autofocus: true,
                          focusNode: _focusNode,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: _isEditingFile
                                ? EditorField(
                                    controller: _notesController,
                                    onChanged: (value) async =>
                                        await _saveFileContent(context),
                                    undoController: _undoHistoryController,
                                    fontSize: context
                                        .watch<EditorConfigProvider>()
                                        .fontSize,
                                  )
                                : GestureDetector(
                                    onDoubleTap: () {
                                      setState(() =>
                                          _isEditingFile = !_isEditingFile);
                                    },
                                    child: _notesController.text.isEmpty
                                        ? SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                .height,
                                            child: Text(
                                              'Double click screen or hit the pencil icon in the top right corner to write!',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
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
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _focusNode.dispose();
    _tocController.dispose();
    super.dispose();
  }
}
