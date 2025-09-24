import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listen_sharing_intent/listen_sharing_intent.dart';

import 'package:printnotes/providers/settings_provider.dart';
import 'package:printnotes/providers/selecting_provider.dart';
import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/providers/customization_provider.dart';

import 'package:printnotes/utils/handlers/style_handler.dart';
import 'package:printnotes/utils/handlers/item_move.dart';
import 'package:printnotes/utils/handlers/item_delete.dart';

import 'package:printnotes/ui/screens/layout/grid_list_view.dart';
import 'package:printnotes/ui/screens/layout/tree_view.dart';

import 'package:printnotes/ui/components/app_bar_drag_wrapper.dart';
import 'package:printnotes/ui/components/drawer_rail.dart';
import 'package:printnotes/ui/widgets/speed_dial_fab.dart';

class NotesDisplay extends StatefulWidget {
  const NotesDisplay({
    super.key,
    required this.updateCanPop,
    required this.onReload,
  });

  final VoidCallback updateCanPop;
  final Function(VoidCallback) onReload;

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  late StreamSubscription _intentSub;
  String? _sharedFilePath;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) _checkMediaIntent();
    _loadItems();
    widget.onReload(_loadItems);
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final readSettings = context.read<SettingsProvider>();
    final readNavProv = context.read<NavigationProvider>();

    // readNavProv.initRouteHistory(readSettings.mainDir);

    await readSettings.loadItems(context, readNavProv.routeHistory.last);

    if (mounted) setState(() => _isLoading = false);
  }

  void _navBack() async {
    context.read<NavigationProvider>().navigateBack();
    await _loadItems();
  }

  Future<void> _refreshPage() async {
    setState(() => _isLoading = true);

    Future.delayed(
        const Duration(milliseconds: 300), () async => await _loadItems());
  }

  List<Uri> selectedItemsToFileEntity() {
    return context
        .read<SelectingProvider>()
        .selectedItems
        .map((item) => Uri.parse(item))
        .toList();
  }

  void _checkMediaIntent() {
    setState(() => _isLoading = true);

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      if (value.isNotEmpty) {
        setState(() => _sharedFilePath = value[0].path);
      }
    }, onError: (e) {
      debugPrint('getIntentDataStream error: $e');
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _sharedFilePath = value[0].path;
        });
        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      }
    });
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    if (Platform.isAndroid) _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenLarge = MediaQuery.sizeOf(context).width >= 1000.0;

    final watchSettings = context.watch<SettingsProvider>();
    final items = watchSettings.items;
    final currentPath = watchSettings.currentPath;
    final currentFolderName = watchSettings.currentFolderName;
    final List<String> routeHistory =
        context.watch<NavigationProvider>().routeHistory;

    if (_sharedFilePath != null) {
      File file = File(_sharedFilePath!);
      if (file.existsSync()) {
        _sharedFilePath = null;

        if (context.mounted) {
          context.read<NavigationProvider>().routeItemToPage(context, file.uri);
        }
      }
    }

    Widget layoutView = watchSettings.layout == 'tree'
        ? TreeLayoutView(onChange: _loadItems)
        : GridListView(items: items, onChange: _loadItems);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (routeHistory.length > 1) {
          _navBack();
        } else {
          widget.updateCanPop();
        }
      },
      child: Scaffold(
        appBar: AppBarDragWrapper(
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            centerTitle: true,
            title: Text(currentFolderName),
            leading: context.watch<SelectingProvider>().selectingMode
                ? IconButton(
                    onPressed: () =>
                        context.read<SelectingProvider>().setSelectingMode(),
                    icon: const Icon(Icons.close))
                : routeHistory.length > 1
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _navBack,
                      )
                    : null, //Icon(Icons.home),
            actions: context.watch<SelectingProvider>().selectingMode
                ? [
                    IconButton(
                      tooltip: 'Select All',
                      onPressed: () {
                        context
                            .read<SelectingProvider>()
                            .selectAll(currentPath);
                      },
                      icon: const Icon(Icons.select_all),
                    ),
                    IconButton(
                      tooltip: 'Move Selected',
                      onPressed: () {
                        ItemMoveHandler.showMoveDialog(
                            context, selectedItemsToFileEntity(), _loadItems);
                        context
                            .read<SelectingProvider>()
                            .setSelectingMode(mode: false);
                      },
                      icon: const Icon(Icons.drive_file_move),
                    ),
                    IconButton(
                      tooltip: 'Delete Selected',
                      onPressed: () {
                        ItemDeletionHandler(context).showTrashManyConfirmation(
                            selectedItemsToFileEntity()
                                .map((e) =>
                                    FileSystemEntity.isFileSync(e.toFilePath())
                                        ? File.fromUri(e)
                                        : Directory.fromUri(e))
                                .toList(),
                            _loadItems);
                        context
                            .read<SelectingProvider>()
                            .setSelectingMode(mode: false);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ]
                : [
                    IconButton(
                      tooltip: 'Reload List',
                      icon: const Icon(Icons.refresh),
                      onPressed: _refreshPage,
                    ),
                  ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? const Center(
                    child: Text('Nothing here!'),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshPage,
                    child: isScreenLarge
                        ? Row(
                            children: [
                              SizedBox(width: 50, child: DrawerRailView()),
                              Expanded(child: layoutView),
                            ],
                          )
                        : Container(
                            decoration: context
                                        .watch<CustomizationProvider>()
                                        .bgImagePath !=
                                    null
                                ? BoxDecoration(
                                    image: DecorationImage(
                                        opacity: context
                                            .watch<CustomizationProvider>()
                                            .bgImageOpacity,
                                        repeat: StyleHandler.getBgImageRepeat(
                                            context
                                                .watch<CustomizationProvider>()
                                                .bgImageRepeat),
                                        fit: StyleHandler.getBgImageFit(context
                                            .watch<CustomizationProvider>()
                                            .bgImageFit),
                                        image: FileImage(File(context
                                            .watch<CustomizationProvider>()
                                            .bgImagePath!))),
                                  )
                                : null,
                            child: layoutView),
                  ),
        floatingActionButton: speedDialFAB(
            context,
            currentPath.isNotEmpty
                ? currentPath
                : context.read<SettingsProvider>().mainDir),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
