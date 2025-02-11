import 'package:shared_preferences/shared_preferences.dart';

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
}

// For saving what order items should be displayed in

class UserSortPref {
  static Future<void> setSortOrder(String sortOrder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortOrder', sortOrder);
  }

  static Future<String> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sortOrder') ?? 'default';
  }
}

// For having LaTeX rendered or not

class UserLatexPref {
  static Future<void> setLatexSupport(bool latexRendering) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useLatex', latexRendering);
  }

  static Future<bool> getLatexSupport() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useLatex') ?? false;
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
}
