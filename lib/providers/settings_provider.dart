import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:printnotes/providers/navigation_provider.dart';
import 'package:printnotes/utils/storage_system.dart';
import 'package:printnotes/utils/handlers/item_sort.dart';
import 'package:printnotes/utils/configs/user_intro.dart';
import 'package:printnotes/utils/configs/data_path.dart';
import 'package:printnotes/utils/configs/user_preference.dart';

class SettingsProvider with ChangeNotifier {
  bool _showIntro = true;
  String _mainDir = '';
  String _archivePath = '';
  String _trashPath = '';
  String _layout = 'grid';
  int _previewLength = 100;
  String _folderPriority = 'none';
  String _sortOrder = 'default';
  bool _hideTitleBar = false;
  bool _useLatex = false;
  bool _useFrontmatter = false;
  String? _bgImagePath;
  double _bgImageOpacity = 0.5;
  String _bgImageFit = 'cover';
  String _bgImageRepeat = 'noRepeat';
  double _noteTileOpacity = 1;
  String _noteTileShape = 'round';
  double _noteTilePadding = 10;
  double _noteTileSpacing = 4;
  double _noteEditorPadding = 8;

  bool get showIntro => _showIntro;
  String get mainDir => _mainDir;
  String get archivePath => _archivePath;
  String get trashPath => _trashPath;
  String get layout => _layout;
  int get previewLength => _previewLength;
  String get folderPriority => _folderPriority;
  String get sortOrder => _sortOrder;
  bool get hideTitleBar => _hideTitleBar;
  bool get useLatex => _useLatex;
  bool get useFrontmatter => _useFrontmatter;
  String? get bgImagePath => _bgImagePath;
  double get bgImageOpacity => _bgImageOpacity;
  String get bgImageFit => _bgImageFit;
  String get bgImageRepeat => _bgImageRepeat;
  double get noteTileOpacity => _noteTileOpacity;
  String get noteTileShape => _noteTileShape;
  double get noteTilePadding => _noteTilePadding;
  double get noteTileSpacing => _noteTileSpacing;
  double get noteEditorPadding => _noteEditorPadding;

  SettingsProvider() {
    loadSettings();
    getShowIntro();
  }

  void getShowIntro() async {
    final showIntro = await UserFirstTime.getShowIntro;
    setShowIntro(showIntro);
  }

  void setShowIntro(bool showIntro) {
    _showIntro = showIntro;
    UserFirstTime.setShowIntro(showIntro);
    notifyListeners();
  }

  void loadSettings() async {
    final mainDir = await DataPath.selectedDirectory;
    final layout = await UserLayoutPref.getLayoutView();
    final previewLength = await UserLayoutPref.getNotePreviewLength();
    final folderPriority = await UserSortPref.getFolderPriority();
    final sortOrder = await UserSortPref.getSortOrder();
    final titleBar = await UserAdvancedPref.getTitleBarVisibility();
    final useLatex = await UserAdvancedPref.getLatexSupport();
    final useFM = await UserAdvancedPref.getFrontmatterSupport();
    final bgImgPath = await UserStylePref.getBgImagePath();
    final bgImgOpacity = await UserStylePref.getBgImageOpacity();
    final bgImgFit = await UserStylePref.getBgImageFit();
    final bgImgRepeat = await UserStylePref.getBgImageRepeat();
    final noteTileOpacity = await UserStylePref.getNoteTileOpacity();
    final noteTileShape = await UserStylePref.getNoteTileShape();
    final noteTilePadding = await UserStylePref.getNoteTilePadding();
    final noteTileSpacing = await UserStylePref.getNoteTileSpacing();
    final noteEditorPadding = await UserStylePref.getNoteEditorPadding();

    if (mainDir != null) setHiddenFolders(mainDir);

    setMainDir(mainDir ?? '');
    setLayout(layout);
    setPreviewLength(previewLength);
    setFolderPriority(folderPriority);
    setSortOrder(sortOrder);
    setTitleBarVisibility(titleBar);
    setLatexUse(useLatex);
    setFrontMatterUse(useFM);
    setBgImagePath(bgImgPath);
    setBgImageOpacity(bgImgOpacity);
    setBgImageFit(bgImgFit);
    setBgImageRepeat(bgImgRepeat);
    setNoteTileOpacity(noteTileOpacity);
    setNoteTileShape(noteTileShape);
    setNoteTilePadding(noteTilePadding);
    setNoteTileSpacing(noteTileSpacing);
    setNoteEditorPadding(noteEditorPadding);
  }

  void setMainDir(String dir) {
    _mainDir = dir;
    DataPath.setSelectedDirectory(dir);
    setHiddenFolders(dir);
    notifyListeners();
  }

  void setHiddenFolders(String dir) {
    _archivePath = path.join(mainDir, '.archive');
    _trashPath = path.join(mainDir, '.trash');
  }

  void setLayout(String layout) {
    _layout = layout;
    UserLayoutPref.setLayoutView(layout);
    notifyListeners();
  }

  void setPreviewLength(int previewLength) {
    _previewLength = previewLength;
    UserLayoutPref.setNotePreviewLength(previewLength);
    notifyListeners();
  }

  void setFolderPriority(String folderPriority) {
    _folderPriority = folderPriority;
    UserSortPref.setFolderPriority(folderPriority);
    notifyListeners();
  }

  void setSortOrder(String sortOrder) {
    _sortOrder = sortOrder;
    UserSortPref.setSortOrder(sortOrder);
    notifyListeners();
  }

  void setTitleBarVisibility(bool visibility) {
    _hideTitleBar = visibility;
    UserAdvancedPref.setTitleBarVisibility(visibility);
    notifyListeners();
  }

  void setLatexUse(bool useLatex) {
    _useLatex = useLatex;
    UserAdvancedPref.setLatexSupport(useLatex);
    notifyListeners();
  }

  void setFrontMatterUse(bool useFM) {
    _useFrontmatter = useFM;
    UserAdvancedPref.setFrontmatterSupport(useFM);
    notifyListeners();
  }

  void setBgImagePath(String? path) {
    _bgImagePath = path;
    UserStylePref.setBgImagePath(path);
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

  Future<Map<String, dynamic>> loadItems(
    BuildContext context,
    String? folderPath,
  ) async {
    final mainPath = context.read<SettingsProvider>().mainDir;
    String directory = folderPath ?? mainPath;
    String folderPriority = context.read<SettingsProvider>().folderPriority;
    String sortOrder = context.read<SettingsProvider>().sortOrder;
    String currentFolderName = 'Notes';

    // Check if path not a file, if so return to mainDir
    if (!await FileSystemEntity.isDirectory(directory)) {
      if (context.mounted) {
        context.read<NavigationProvider>().routeHistory.clear();
        context.read<NavigationProvider>().routeHistory.add(mainPath);
      }
      directory = mainPath;
    }

    final items = await StorageSystem.listFolderContents(directory);
    final sortedItems =
        ItemSortHandler.getSortedItems(items, folderPriority, sortOrder);

    if (directory != mainPath) {
      currentFolderName = path.basename(directory);
    } else {
      currentFolderName;
    }

    return {
      'items': sortedItems,
      'currentPath': directory,
      'currentFolderName': currentFolderName,
    };
  }
}
