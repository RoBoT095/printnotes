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
  bool _hideTitleBar = false;
  bool _useLatex = false;
  bool _useFrontmatter = false;

  String _mainDir = '';
  String _archivePath = '';
  String _trashPath = '';

  String _layout = 'grid';
  String _folderPriority = 'none';
  String _sortOrder = 'default';

  String _currentPath = '';
  String _currentFolderName = 'Notes';
  List<FileSystemEntity> _items = [];

  List<String> _tagList = [];
  List<String> _recentFilesList = [];

  bool _isTagFolder(String folder) => folder.startsWith('※');
  bool _isRecentFolder(String folder) => folder.startsWith('⏱');

  List<FileSystemEntity> _trashItems = [];
  List<FileSystemEntity> _archiveItems = [];

  // ===========================

  bool get showIntro => _showIntro;
  bool get hideTitleBar => _hideTitleBar;
  bool get useLatex => _useLatex;
  bool get useFrontmatter => _useFrontmatter;

  String get mainDir => _mainDir;
  String get archivePath => _archivePath;
  String get trashPath => _trashPath;

  String get layout => _layout;
  String get folderPriority => _folderPriority;
  String get sortOrder => _sortOrder;

  String get currentPath => _currentPath;
  String get currentFolderName => _currentFolderName;
  List<FileSystemEntity> get items => _items;

  List<String> get tagList => _tagList;
  List<String> get recentFilesList => _recentFilesList;

  List<FileSystemEntity> get trashItems => _trashItems;
  List<FileSystemEntity> get archiveItems => _archiveItems;

  SettingsProvider() {
    loadSettings();
    getShowIntro();
  }

  void getShowIntro() {
    final showIntro = UserFirstTime.getShowIntro;
    setShowIntro(showIntro);
  }

  void setShowIntro(bool showIntro) {
    _showIntro = showIntro;
    UserFirstTime.setShowIntro(showIntro);
    notifyListeners();
  }

  void getTagList() async {
    Map<String, List<String>> tagMap = await StorageSystem.getAllTags(mainDir);
    _tagList = tagMap.keys.toList();
    notifyListeners();
  }

  void addRecentFile(String path) {
    DataPath.addRecentFile(path);
  }

  void loadRecentFiles() {
    _recentFilesList = DataPath.loadRecentFiles(Duration(days: 7));
    notifyListeners();
  }

  void loadSettings() async {
    final mainDir = await DataPath.selectedDirectory;

    if (mainDir != null) setHiddenFolders(mainDir);

    setMainDir(mainDir ?? '');
    setLayout(UserLayoutPref.getLayoutView());
    setFolderPriority(UserSortPref.getFolderPriority());
    setSortOrder(UserSortPref.getSortOrder());
    setTitleBarVisibility(UserAdvancedPref.getTitleBarVisibility());
    setLatexUse(UserAdvancedPref.getLatexSupport());
    setFrontMatterUse(UserAdvancedPref.getFrontmatterSupport());
  }

  void setMainDir(String dir) {
    _mainDir = dir;
    DataPath.setSelectedDirectory(dir);
    setHiddenFolders(dir);
    notifyListeners();
  }

  void setHiddenFolders(String dir) {
    _archivePath = path.join(dir, '.archive');
    _trashPath = path.join(dir, '.trash');
  }

  void setLayout(String layout) {
    _layout = layout;
    UserLayoutPref.setLayoutView(layout);
    notifyListeners();
  }

  void setFolderPriority(String folderPriority) {
    _folderPriority = folderPriority;
    UserSortPref.setFolderPriority(folderPriority);
    loadItems(null, _currentPath);
    notifyListeners();
  }

  void setSortOrder(String sortOrder) {
    _sortOrder = sortOrder;
    UserSortPref.setSortOrder(sortOrder);
    loadItems(null, _currentPath);
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
    loadItems(null, _currentPath);
    notifyListeners();
  }

  void setFrontMatterUse(bool useFM) {
    _useFrontmatter = useFM;
    UserAdvancedPref.setFrontmatterSupport(useFM);
    loadItems(null, _currentPath);
    notifyListeners();
  }

  Future<void> loadTrash(String trashPath) async {
    _trashItems = await StorageSystem.listFolderContents(Uri.parse(trashPath),
        showHidden: true);
    notifyListeners();
  }

  Future<void> loadArchive(String archivePath) async {
    _archiveItems = await StorageSystem.listFolderContents(
        Uri.parse(archivePath),
        showHidden: true);
    notifyListeners();
  }

  Future<void> loadItems(
    BuildContext? context,
    String folder,
  ) async {
    String currentFolderName = 'Notes';
    bool isTag = false;
    List<FileSystemEntity> filesWithTags = [];
    bool isRecentFiles = false;

    // Check if path not a file, if not, check if it is a tag, if not, return to mainDir
    if (!await FileSystemEntity.isDirectory(folder)) {
      if (_isTagFolder(folder)) {
        // Tag UTF-8 icon unicode value: U+203B aka REFERENCE MARK
        folder = folder.replaceFirst('※', '');
        isTag = true;
        Map<String, List<String>> tagMap =
            await StorageSystem.getAllTags(mainDir);
        if (tagMap[folder] != null) {
          filesWithTags.addAll(tagMap[folder]!.map((e) => File(e)));
        }
      } else if (_isRecentFolder(folder)) {
        // Recent UTF-8 icon unicode value: U+23F1 aka STOPWATCH
        folder = 'Recently Opened';
        isRecentFiles = true;
        loadRecentFiles();
      } else {
        if (context != null && context.mounted) {
          context.read<NavigationProvider>().routeHistory.clear();
          context.read<NavigationProvider>().routeHistory.add(mainDir);
        }
        folder = mainDir;
      }
    }

    final List<FileSystemEntity> items = isTag
        ? filesWithTags
        : isRecentFiles
            ? recentFilesList
                .map(
                  (e) => File(e),
                )
                .toList()
            : await StorageSystem.listFolderContents(Uri.parse(folder));

    final sortedItems =
        ItemSortHandler(sortOrder, folderPriority).getSortedItems(items);
    if (isTag) {
      currentFolderName = folder;
    } else if (folder != mainDir) {
      currentFolderName = path.basename(folder);
    } else {
      currentFolderName;
    }

    _items = sortedItems;
    _currentPath = folder;
    _currentFolderName = currentFolderName;

    notifyListeners();
  }
}
