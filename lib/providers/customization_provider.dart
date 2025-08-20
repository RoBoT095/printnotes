import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class CustomizationProvider with ChangeNotifier {
  String? _bgImagePath;
  double _bgImageOpacity = 0.5;
  String _bgImageFit = 'cover';
  String _bgImageRepeat = 'noRepeat';
  double _noteTileOpacity = 1;
  String _noteTileShape = 'round';
  double _noteTilePadding = 10;
  double _noteTileSpacing = 4;
  double _noteEditorPadding = 8;
  int _previewLength = 100;

  String? get bgImagePath => _bgImagePath;
  double get bgImageOpacity => _bgImageOpacity;
  String get bgImageFit => _bgImageFit;
  String get bgImageRepeat => _bgImageRepeat;
  double get noteTileOpacity => _noteTileOpacity;
  String get noteTileShape => _noteTileShape;
  double get noteTilePadding => _noteTilePadding;
  double get noteTileSpacing => _noteTileSpacing;
  double get noteEditorPadding => _noteEditorPadding;
  int get previewLength => _previewLength;

  void loadCustomizations() async {
    final bgImgPath = await UserStylePref.getBgImagePath();
    final bgImgOpacity = await UserStylePref.getBgImageOpacity();
    final bgImgFit = await UserStylePref.getBgImageFit();
    final bgImgRepeat = await UserStylePref.getBgImageRepeat();
    final noteTileOpacity = await UserStylePref.getNoteTileOpacity();
    final noteTileShape = await UserStylePref.getNoteTileShape();
    final noteTilePadding = await UserStylePref.getNoteTilePadding();
    final noteTileSpacing = await UserStylePref.getNoteTileSpacing();
    final noteEditorPadding = await UserStylePref.getNoteEditorPadding();
    final previewLength = await UserLayoutPref.getNotePreviewLength();

    setBgImagePath(bgImgPath);
    setBgImageOpacity(bgImgOpacity);
    setBgImageFit(bgImgFit);
    setBgImageRepeat(bgImgRepeat);
    setNoteTileOpacity(noteTileOpacity);
    setNoteTileShape(noteTileShape);
    setNoteTilePadding(noteTilePadding);
    setNoteTileSpacing(noteTileSpacing);
    setNoteEditorPadding(noteEditorPadding);
    setPreviewLength(previewLength);
  }

  void setBgImagePath(String? path) {
    String? imgPath;
    if (path != null && File(path).existsSync()) {
      imgPath = path;
    }
    _bgImagePath = imgPath;
    UserStylePref.setBgImagePath(imgPath);
    notifyListeners();
  }

  /// Opacity must be a value between 0.0 and 1
  void setBgImageOpacity(double opacity) {
    _bgImageOpacity = opacity;
    UserStylePref.setBgImageOpacity(opacity);
    notifyListeners();
  }

  void setBgImageFit(String fit) {
    _bgImageFit = fit;
    UserStylePref.setBgImageFit(fit);
    notifyListeners();
  }

  void setBgImageRepeat(String repeat) {
    _bgImageRepeat = repeat;
    UserStylePref.setBgImageRepeat(repeat);
    notifyListeners();
  }

  /// Opacity must be a value between 0.0 and 1
  void setNoteTileOpacity(double opacity) {
    opacity = opacity;
    _noteTileOpacity = opacity;
    UserStylePref.setNoteTileOpacity(opacity);
    notifyListeners();
  }

  void setNoteTileShape(String shape) {
    _noteTileShape = shape;
    UserStylePref.setNoteTileShape(shape);
    notifyListeners();
  }

  void setNoteTilePadding(double padding) {
    _noteTilePadding = padding;
    UserStylePref.setNoteTilePadding(padding);
    notifyListeners();
  }

  void setNoteTileSpacing(double spacing) {
    _noteTileSpacing = spacing;
    UserStylePref.setNoteTileSpacing(spacing);
    notifyListeners();
  }

  void setNoteEditorPadding(double padding) {
    _noteEditorPadding = padding;
    UserStylePref.setNoteEditorPadding(padding);
    notifyListeners();
  }

  void setPreviewLength(int previewLength) {
    _previewLength = previewLength;
    UserLayoutPref.setNotePreviewLength(previewLength);
    notifyListeners();
  }
}
