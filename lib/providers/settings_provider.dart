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
  String _folderPriority = 'none';
  String _sortOrder = 'default';
  bool _hideTitleBar = false;
  bool _useLatex = false;
  bool _useFrontmatter = false;
  List<String> _tagList = [];

  bool get showIntro => _showIntro;
  String get mainDir => _mainDir;
  String get archivePath => _archivePath;
  String get trashPath => _trashPath;
  String get layout => _layout;
  String get folderPriority => _folderPriority;
  String get sortOrder => _sortOrder;
  bool get hideTitleBar => _hideTitleBar;
  bool get useLatex => _useLatex;
  bool get useFrontmatter => _useFrontmatter;
  List<String> get tagList => _tagList;

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

  Future<Map<String, List<String>>> getTagMap() async {
    return await StorageSystem.getAllTags(mainDir);
  }

  void getTagList() async {
    Map<String, List<String>> tagMap = await getTagMap();
    _tagList = tagMap.keys.toList();
    notifyListeners();
  }

  void loadSettings() async {
    final mainDir = await DataPath.selectedDirectory;
    final layout = await UserLayoutPref.getLayoutView();
    final folderPriority = await UserSortPref.getFolderPriority();
    final sortOrder = await UserSortPref.getSortOrder();
    final titleBar = await UserAdvancedPref.getTitleBarVisibility();
    final useLatex = await UserAdvancedPref.getLatexSupport();
    final useFM = await UserAdvancedPref.getFrontmatterSupport();

    if (mainDir != null) setHiddenFolders(mainDir);

    setMainDir(mainDir ?? '');
    setLayout(layout);
    setFolderPriority(folderPriority);
    setSortOrder(sortOrder);
    setTitleBarVisibility(titleBar);
    setLatexUse(useLatex);
    setFrontMatterUse(useFM);
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

  Future<Map<String, dynamic>> loadItems(
    BuildContext context,
    String? folderPath,
  ) async {
    final mainPath = context.read<SettingsProvider>().mainDir;
    String directory = folderPath ?? mainPath;
    String folderPriority = context.read<SettingsProvider>().folderPriority;
    String sortOrder = context.read<SettingsProvider>().sortOrder;
    String currentFolderName = 'Notes';
    bool isTag = false;
    List<FileSystemEntity> filesWithTags = [];

    // Check if path not a file, if not, check if it is a tag, if not, return to mainDir
    if (!await FileSystemEntity.isDirectory(directory)) {
      if (directory.startsWith('#')) {
        isTag = true;
        Map<String, List<String>> tagMap = await getTagMap();
        if (tagMap[directory] != null) {
          filesWithTags.addAll(tagMap[directory]!.map((e) => File(e)));
        }
      } else {
        if (context.mounted) {
          context.read<NavigationProvider>().routeHistory.clear();
          context.read<NavigationProvider>().routeHistory.add(mainPath);
        }
        directory = mainPath;
      }
    }

    final items = isTag
        ? filesWithTags
        : await StorageSystem.listFolderContents(directory);
    final sortedItems =
        ItemSortHandler(sortOrder, folderPriority).getSortedItems(items);
    if (isTag) {
      currentFolderName = directory;
    } else if (directory != mainPath) {
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
