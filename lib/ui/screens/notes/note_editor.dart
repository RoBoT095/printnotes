import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/editor_config_provider.dart';

import 'package:printnotes/utils/open_explorer.dart';
import 'package:printnotes/utils/parsers/frontmatter_parser.dart';
import 'package:printnotes/utils/parsers/csv_parser.dart';

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

  DateTime? _lastModifiedTime;
  Timer? _fileCheckTimer;
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;

  static const Duration autoSaveInterval = Duration(seconds: 3);
  static const Duration fileCheckInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();

    _notesController = TextEditingController();
    _loadFileContent();

    _fileCheckTimer =
        Timer.periodic(fileCheckInterval, (_) => _checkForExternalChanges());
  }

  Future<void> _loadFileContent() async {
    try {
      final file = File(widget.filePath);
      final content = await file.readAsString();
      final lastMod = await file.lastModified();

      setState(() {
        _notesController.text = content;
        _lastModifiedTime = lastMod;
        _isLoading = false;
        _hasUnsavedChanges = false;
      });
    } catch (e) {
      debugPrint('Error loading file content: $e');
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  void _setUpAutoSave() {
    _autoSaveTimer?.cancel();
    _hasUnsavedChanges = true;

    _autoSaveTimer = Timer(autoSaveInterval, () {
      if (_hasUnsavedChanges && context.mounted) {
        _saveFileContent(context);
        _hasUnsavedChanges = false;
      }
    });
  }

  Future<void> _checkForExternalChanges() async {
    if (_isError || _isLoading) return;

    try {
      final file = File(widget.filePath);
      final lastMod = await file.lastModified();

      if (_lastModifiedTime != null &&
          lastMod.isAfter(_lastModifiedTime!) &&
          mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('File Changed'),
            content: const Text(
                'This file has been modified outside the app. Would you like to reload it?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveFileContent(context);
                },
                child: const Text('Keep My Changes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _loadFileContent();
                },
                child: const Text('Reload File'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error checking file modification: $e');
    }
  }

  Future<bool> _saveFileContent(BuildContext context) async {
    if (_isError) return true;
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_notesController.text);

      _lastModifiedTime = DateTime.now();
      _hasUnsavedChanges = false;

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
    bool useFM = context.read<SettingsProvider>().useFrontmatter;
    String? fmBody;
    String? fmTitle;

    if (useFM) {
      final doc = FrontmatterHandleParsing.getParsedData(_notesController.text);
      fmTitle =
          FrontmatterHandleParsing.getTagString(_notesController.text, 'title');
      if (doc != null) fmBody = doc.body;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        bool canPop =
            _hasUnsavedChanges ? await _saveFileContent(context) : true;
        if (canPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        appBar: AppBar(
          centerTitle: false,
          title: SelectableText(
            fmTitle ?? widget.filePath.split('/').last,
            maxLines: 1,
          ),
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
        body: buildMarkdownView(fmBody ?? _notesController.text),
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

  Widget buildMarkdownView(String previewBody) {
    if (widget.filePath.endsWith('.csv')) {
      previewBody = csvToMarkdownTable(previewBody);
    }
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
                  onValueChange: (value) => _setUpAutoSave(),
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
                                    onChanged: (value) => _setUpAutoSave(),
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
                                            data: previewBody,
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
    if (_hasUnsavedChanges && context.mounted) {
      _saveFileContent(context);
    }

    _notesController.dispose();
    _focusNode.dispose();
    _tocController.dispose();
    _fileCheckTimer?.cancel();
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}
