import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_flow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:printnotes/utils/open_explorer.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';

class SketchPad extends StatefulWidget {
  const SketchPad({super.key, required this.sketchUri});

  final Uri sketchUri;

  @override
  State<SketchPad> createState() => _SketchPadState();
}

class _SketchPadState extends State<SketchPad> {
  final _sketchController =
      SketchController(sketchConfig: SketchConfig(showEraserEffect: true));
  final GlobalKey _repaintKey = GlobalKey();
  final _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final data = await File.fromUri(widget.sketchUri).readAsBytes();

      _sketchController.fromBson(bson: data);
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error loading sketch content: $e');
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  Future<bool> _saveSketch(BuildContext context) async {
    if (_isError) return true;

    try {
      await File.fromUri(widget.sketchUri)
          .writeAsBytes(_sketchController.toBson());
      return true;
    } catch (e) {
      debugPrint('Error saving sketch file: $e');
      if (context.mounted) {
        customSnackBar('Error saving sketch file', type: 'error').show(context);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool canPop = await _saveSketch(context);

        if (canPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: _sketchController.canUndoNotifier,
              builder: (context, canUndo, _) {
                return IconButton(
                  icon: Icon(Icons.undo_rounded),
                  onPressed: canUndo ? () => _sketchController.undo() : null,
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _sketchController.canRedoNotifier,
              builder: (context, canRedo, _) {
                return IconButton(
                  icon: Icon(Icons.redo_rounded),
                  onPressed: canRedo ? () => _sketchController.redo() : null,
                );
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry>[
                // PopupMenuItem(
                //     child: ListTile(
                //   leading: Icon(Icons.image_outlined),
                //   title: Text('Export PNG'),
                //   onTap: () {}, // TODO: make it work
                // )),
                // PopupMenuItem(
                //     child: ListTile(
                //   leading: Icon(Icons.format_shapes),
                //   title: Text('Export SVG'),
                //   onTap: () {}, // TODO: make it work
                // )),

                // TODO: make another popup menu to share as SVG or PNG
                // if (!Platform
                //     .isLinux) // Is currently files not supported by SharePlus
                //   PopupMenuItem(
                //     child: ListTile(
                //       leading: const Icon(Icons.share),
                //       title: Text('Share'),
                //       onTap: () {
                //         SharePlus.instance.share(ShareParams(
                //             files: [XFile(widget.sketchUri.toFilePath())]));
                //       },
                //     ),
                //   ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.folder_open),
                    title: const Text("Open Location"),
                    iconColor: mobileNullColor(context),
                    textColor: mobileNullColor(context),
                  ),
                  onTap: () async => await openExplorer(
                      context, widget.sketchUri.toFilePath()),
                ),
              ],
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _isError
                ? Center(
                    child: Text('Error loading sketch data'),
                  )
                : Center(
                    child: SketchBoard(
                      controller: _sketchController,
                      repaintKey: _repaintKey,
                    ),
                  ),
        bottomNavigationBar: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SketchBottomBar(
            controller: _sketchController,
            bottomBarColor: Theme.of(context).colorScheme.surface,
            moveIcon: SketchToolIcon(
              enableIcon: Icon(Icons.pinch),
              disableIcon: Icon(Icons.pinch_outlined),
            ),
            pencilIcon: SketchToolIcon(
              enableIcon: Icon(Icons.mode_edit_outline),
              disableIcon: Icon(Icons.mode_edit_outline_outlined),
            ),
            brushIcon: SketchToolIcon(
                enableIcon: Icon(Icons.brush),
                disableIcon: Icon(Icons.brush_outlined)),
            highlighterIcon: SketchToolIcon(
              enableIcon: Icon(
                FontAwesomeIcons.highlighter,
                opticalSize: 20,
              ),
              disableIcon: Icon(
                FontAwesomeIcons.highlighter,
                opticalSize: 20,
              ),
            ),
            eraserIcon: SketchToolIcon(
              enableIcon: Icon(
                FontAwesomeIcons.eraser,
                opticalSize: 20,
              ),
              disableIcon: Icon(
                FontAwesomeIcons.eraser,
                opticalSize: 20,
              ),
            ),
            lineIcon: SketchToolIcon(
              enableIcon: Icon(Icons.show_chart),
              disableIcon: Icon(Icons.show_chart_outlined),
            ),
            rectangleIcon: SketchToolIcon(
              enableIcon: Icon(Icons.rectangle),
              disableIcon: Icon(Icons.rectangle_outlined),
            ),
            circleIcon: SketchToolIcon(
              enableIcon: Icon(Icons.circle),
              disableIcon: Icon(Icons.circle_outlined),
            ),
            paletteIcon: Icon(Icons.palette),
            clearIcon: Icon(Icons.cleaning_services_rounded),
            showColorPickerSliderBar: true,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sketchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
