import 'package:shared_preferences/shared_preferences.dart';

// TODO: Add button to reset all settings including config file
// Delete all set preferences
Future<void> clearAllPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

// For layout selection

// Left it as a string in case I want to add more layouts
class UserLayoutPref {
  static Future<void> setLayoutView(String layoutView) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('layoutView', layoutView);
  }

  static Future<String> getLayoutView() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('layoutView') ?? 'grid';
  }

  // Note preview length is for how many characters are displayed for each note
  // body on home screen before they get cut off
  static Future<void> setNotePreviewLength(int viewLength) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notePreview', viewLength);
  }

  static Future<int> getNotePreviewLength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('notePreview') ?? 100;
  }
}

// For styling of app

class UserThemingPref {
  static Future<void> setThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'system';
  }

  static Future<void> setColorScheme(String colorScheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('colorScheme', colorScheme);
  }

  static Future<String> getColorScheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('colorScheme') ?? 'default';
  }

  static Future<void> setPureBlackBG(bool pureBlackBG) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usePureBlack', pureBlackBG);
  }

  static Future<bool> getPureBlackBG() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('usePureBlack') ?? false;
  }

  static Future<void> setCodeHighlight(String highlight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('codeHighlight', highlight);
  }

  static Future<String> getCodeHighlight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('codeHighlight') ?? '';
  }
}

class UserStylePref {
  static Future<void> setBgImagePath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bgImgPath', path ?? '');
  }

  static Future<String?> getBgImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('bgImgPath');
    return path == '' ? null : path;
  }

  static Future<void> setBgImageOpacity(double opacity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bgImgOpacity', opacity);
  }

  static Future<double> getBgImageOpacity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('bgImgOpacity') ?? 0.5;
  }

  static Future<void> setBgImageFit(String fit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bgImgFit', fit);
  }

  static Future<String> getBgImageFit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bgImgFit') ?? 'cover';
  }

  static Future<void> setBgImageRepeat(String repeat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bgImgRepeat', repeat);
  }

  static Future<String> getBgImageRepeat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bgImgRepeat') ?? 'noRepeat';
  }

  static Future<void> setNoteTileOpacity(double opacity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('noteTileOpacity', opacity);
  }

  static Future<double> getNoteTileOpacity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('noteTileOpacity') ?? 1;
  }

  static Future<void> setNoteTileShape(String shape) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('noteTileShape', shape);
  }

  static Future<String> getNoteTileShape() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('noteTileShape') ?? 'round';
  }

  static Future<void> setNoteTilePadding(double padding) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('noteTilePadding', padding);
  }

  static Future<double> getNoteTilePadding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('noteTilePadding') ?? 10;
  }

  static Future<void> setNoteTileSpacing(double spacing) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('noteTileSpacing', spacing);
  }

  static Future<double> getNoteTileSpacing() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('noteTileSpacing') ?? 4;
  }

  static Future<void> setNoteEditorPadding(double padding) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('noteEditorPadding', padding);
  }

  static Future<double> getNoteEditorPadding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('noteEditorPadding') ?? 8;
  }
}

// For saving what order items should be displayed in

class UserSortPref {
  static Future<void> setFolderPriority(String folderPriority) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('folderPriority', folderPriority);
  }

  static Future<String> getFolderPriority() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('folderPriority') ?? 'none';
  }

  static Future<void> setSortOrder(String sortOrder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortOrder', sortOrder);
  }

  static Future<String> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sortOrder') ?? 'default';
  }
}

class UserAdvancedPref {
  // For hiding and showing title bar on desktop
  static Future<void> setTitleBarVisibility(bool visibility) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('titleBarVisibility', visibility);
  }

  static Future<bool> getTitleBarVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('titleBarVisibility') ?? false;
  }

  // For having LaTeX rendered or not
  static Future<void> setLatexSupport(bool latexRendering) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useLatex', latexRendering);
  }

  static Future<bool> getLatexSupport() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useLatex') ?? false;
  }

  // For using Frontmatter for metadata of not
  static Future<void> setFrontmatterSupport(bool useFM) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFrontmatter', useFM);
  }

  static Future<bool> getFrontmatterSupport() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useFrontmatter') ?? false;
  }
}

// For Editor settings

class UserEditorConfig {
  static Future<void> setFontSize(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('editorConfigFontSize', fontSize);
  }

  static Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('editorConfigFontSize') ?? 16;
  }

  // static Future<void> setToolbarConfig(String config) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('toolbar_config', config);
  // }

  // static Future<String?> getToolbarConfig() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('toolbar_config');
  // }
}
