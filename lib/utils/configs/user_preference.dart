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
