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
  String _sortOrder = 'default';
  bool _useLatex = false;

  bool get showIntro => _showIntro;
  String get mainDir => _mainDir;
  String get archivePath => _archivePath;
  String get trashPath => _trashPath;
  String get layout => _layout;
  int get previewLength => _previewLength;
  String get sortOrder => _sortOrder;
  bool get useLatex => _useLatex;

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
    final sortOrder = await UserSortPref.getSortOrder();
    final useLatex = await UserLatexPref.getLatexSupport();

    if (mainDir != null) setHiddenFolders(mainDir);

    setMainDir(mainDir ?? '');
    setLayout(layout);
    setPreviewLength(previewLength);
    setSortOrder(sortOrder);
    setLatexUse(useLatex);
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

  void setSortOrder(String sortOrder) {
    _sortOrder = sortOrder;
    UserSortPref.setSortOrder(sortOrder);
    notifyListeners();
  }

  void setLatexUse(bool useLatex) {
    _useLatex = useLatex;
    UserLatexPref.setLatexSupport(useLatex);
    notifyListeners();
  }

  Map<String, dynamic> loadItems(
    BuildContext context,
    String? folderPath,
  ) {
    final mainPath = context.read<SettingsProvider>().mainDir;
    String directory = folderPath ?? mainPath;
    String sortOrder = context.read<SettingsProvider>().sortOrder;
    String currentFolderName = 'All Notes';

    // Check if path not a file, if so return to mainDir
    if (!FileSystemEntity.isDirectorySync(directory)) {
      context.read<NavigationProvider>().routeHistory.clear();
      context.read<NavigationProvider>().routeHistory.add(mainPath);
      directory = mainPath;
    }

    final items = StorageSystem.listFolderContents(directory);
    final sortedItems = ItemSortHandler.sortItems(items, sortOrder);

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
