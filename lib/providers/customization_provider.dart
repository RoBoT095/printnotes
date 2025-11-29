import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class CustomizationProvider with ChangeNotifier {
  String? _bgImgPath;
  double _bgImgOpacity = 0.5;
  String _bgImgFit = 'cover';
  String _bgImgRepeat = 'noRepeat';
  double _noteTileOpacity = 1;
  String _noteTileShape = 'round';
  double _noteTilePadding = 10;
  double _noteTileSpacing = 4;
  double _noteEditorPadding = 8;
  int _previewLength = 100;

  String? get bgImagePath => _bgImgPath;
  double get bgImageOpacity => _bgImgOpacity;
  String get bgImageFit => _bgImgFit;
  String get bgImageRepeat => _bgImgRepeat;
  double get noteTileOpacity => _noteTileOpacity;
  String get noteTileShape => _noteTileShape;
  double get noteTilePadding => _noteTilePadding;
  double get noteTileSpacing => _noteTileSpacing;
  double get noteEditorPadding => _noteEditorPadding;
  int get previewLength => _previewLength;

  CustomizationProvider() {
    loadCustomizations();
  }

  void loadCustomizations() {
    _bgImgPath = UserStylePref.getBgImagePath();
    _bgImgOpacity = UserStylePref.getBgImageOpacity();
    _bgImgFit = UserStylePref.getBgImageFit();
    _bgImgRepeat = UserStylePref.getBgImageRepeat();
    _noteTileOpacity = UserStylePref.getNoteTileOpacity();
    _noteTileShape = UserStylePref.getNoteTileShape();
    _noteTilePadding = UserStylePref.getNoteTilePadding();
    _noteTileSpacing = UserStylePref.getNoteTileSpacing();
    _noteEditorPadding = UserStylePref.getNoteEditorPadding();
    _previewLength = UserLayoutPref.getNotePreviewLength();

    notifyListeners();
  }

  void setBgImagePath(String? path) {
    final imgPath = path != null && File(path).existsSync() ? path : null;

    _bgImgPath = imgPath;
    UserStylePref.setBgImagePath(imgPath);
    notifyListeners();
  }

  /// Opacity must be a value between 0.0 and 1
  void setBgImageOpacity(double opacity) {
    _bgImgOpacity = opacity;
    UserStylePref.setBgImageOpacity(opacity);
    notifyListeners();
  }

  void setBgImageFit(String fit) {
    _bgImgFit = fit;
    UserStylePref.setBgImageFit(fit);
    notifyListeners();
  }

  void setBgImageRepeat(String repeat) {
    _bgImgRepeat = repeat;
    UserStylePref.setBgImageRepeat(repeat);
    notifyListeners();
  }

  /// Opacity must be a value between 0.0 and 1
  void setNoteTileOpacity(double opacity) {
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
