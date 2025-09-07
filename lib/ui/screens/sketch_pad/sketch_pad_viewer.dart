import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:printnotes/ui/widgets/custom_snackbar.dart';
import 'package:sketch_flow/sketch_flow.dart';

class SketchPad extends StatefulWidget {
  const SketchPad({super.key, required this.sketchFile});

  final File sketchFile;

  @override
  State<SketchPad> createState() => _SketchPadState();
}

class _SketchPadState extends State<SketchPad> {
  final _sketchController =
      SketchController(sketchConfig: SketchConfig(showEraserEffect: true));
  final GlobalKey _repaintKey = GlobalKey();
  final _scrollController = ScrollController();

  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await widget.sketchFile.readAsBytes();

      _sketchController.fromBson(bson: data);
    } catch (e) {
      debugPrint('Error loading sketch content: $e');
      setState(() {
        _isError = true;
      });
    }
  }

  Future<bool> _saveSketch(BuildContext context) async {
    if (_isError) return true;

    try {
      await widget.sketchFile.writeAsBytes(_sketchController.toBson());
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
    return Scaffold(
      appBar: SketchTopBar(
        controller: _sketchController,
        onClickBackButton: () async {
          bool canPop = await _saveSketch(context);

          if (canPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
      body: _isError
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
          showColorPickerSliderBar: true,
        ),
      ),
    );
  }
}
