import 'package:printnotes/main.dart';

// TODO: Add button to reset all settings including config file
// Delete all set preferences
void clearAllPrefs() {
  App.localStorage.clear();
}

// For layout selection

class UserLayoutPref {
  // Left it as a string in case I want to add more layouts
  static void setLayoutView(String layoutView) {
    App.localStorage.setString('layoutView', layoutView);
  }

  static String getLayoutView() {
    return App.localStorage.getString('layoutView') ?? 'grid';
  }

  // Note preview length is for how many characters are displayed for each note
  // body on home screen before they get cut off
  static void setNotePreviewLength(int viewLength) {
    App.localStorage.setInt('notePreview', viewLength);
  }

  static int getNotePreviewLength() {
    return App.localStorage.getInt('notePreview') ?? 100;
  }
}

// For styling of app

class UserThemingPref {
  static void setThemeMode(String themeMode) {
    App.localStorage.setString('themeMode', themeMode);
  }

  static String getThemeMode() {
    return App.localStorage.getString('themeMode') ?? 'system';
  }

  static void setColorScheme(String colorScheme) {
    App.localStorage.setString('colorScheme', colorScheme);
  }

  static String getColorScheme() {
    return App.localStorage.getString('colorScheme') ?? 'default';
  }

  static void setDynamicColor(bool value) {
    App.localStorage.setBool('useDynamicColor', value);
  }

  static bool getDynamicColor() {
    return App.localStorage.getBool('useDynamicColor') ?? false;
  }

  static void setPureBlackBG(bool value) {
    App.localStorage.setBool('usePureBlack', value);
  }

  static bool getPureBlackBG() {
    return App.localStorage.getBool('usePureBlack') ?? false;
  }

  static void setCodeHighlight(String highlight) {
    App.localStorage.setString('codeHighlight', highlight);
  }

  static String getCodeHighlight() {
    return App.localStorage.getString('codeHighlight') ?? '';
  }
}

class UserStylePref {
  static void setBgImagePath(String? path) {
    App.localStorage.setString('bgImgPath', path ?? '');
  }

  static String? getBgImagePath() {
    final path = App.localStorage.getString('bgImgPath');
    return path == '' ? null : path;
  }

  static void setBgImageOpacity(double opacity) {
    App.localStorage.setDouble('bgImgOpacity', opacity);
  }

  static double getBgImageOpacity() {
    return App.localStorage.getDouble('bgImgOpacity') ?? 0.5;
  }

  static void setBgImageFit(String fit) {
    App.localStorage.setString('bgImgFit', fit);
  }

  static String getBgImageFit() {
    return App.localStorage.getString('bgImgFit') ?? 'cover';
  }

  static void setBgImageRepeat(String repeat) {
    App.localStorage.setString('bgImgRepeat', repeat);
  }

  static String getBgImageRepeat() {
    return App.localStorage.getString('bgImgRepeat') ?? 'noRepeat';
  }

  static void setNoteTileOpacity(double opacity) {
    App.localStorage.setDouble('noteTileOpacity', opacity);
  }

  static double getNoteTileOpacity() {
    return App.localStorage.getDouble('noteTileOpacity') ?? 1;
  }

  static void setNoteTileShape(String shape) {
    App.localStorage.setString('noteTileShape', shape);
  }

  static String getNoteTileShape() {
    return App.localStorage.getString('noteTileShape') ?? 'round';
  }

  static void setNoteTilePadding(double padding) {
    App.localStorage.setDouble('noteTilePadding', padding);
  }

  static double getNoteTilePadding() {
    return App.localStorage.getDouble('noteTilePadding') ?? 10;
  }

  static void setNoteTileSpacing(double spacing) {
    App.localStorage.setDouble('noteTileSpacing', spacing);
  }

  static double getNoteTileSpacing() {
    return App.localStorage.getDouble('noteTileSpacing') ?? 4;
  }

  static void setNoteEditorPadding(double padding) {
    App.localStorage.setDouble('noteEditorPadding', padding);
  }

  static double getNoteEditorPadding() {
    return App.localStorage.getDouble('noteEditorPadding') ?? 8;
  }
}

// For saving what order items should be displayed in

class UserSortPref {
  static void setFolderPriority(String folderPriority) {
    App.localStorage.setString('folderPriority', folderPriority);
  }

  static String getFolderPriority() {
    return App.localStorage.getString('folderPriority') ?? 'none';
  }

  static void setSortOrder(String sortOrder) {
    App.localStorage.setString('sortOrder', sortOrder);
  }

  static String getSortOrder() {
    return App.localStorage.getString('sortOrder') ?? 'default';
  }
}

class UserAdvancedPref {
  // For hiding and showing title bar on desktop
  static void setTitleBarVisibility(bool visibility) {
    App.localStorage.setBool('titleBarVisibility', visibility);
  }

  static bool getTitleBarVisibility() {
    return App.localStorage.getBool('titleBarVisibility') ?? false;
  }

  // For having LaTeX rendered or not
  static void setLatexSupport(bool latexRendering) {
    App.localStorage.setBool('useLatex', latexRendering);
  }

  static bool getLatexSupport() {
    return App.localStorage.getBool('useLatex') ?? false;
  }

  // For using Frontmatter for metadata of not
  static void setFrontmatterSupport(bool useFM) {
    App.localStorage.setBool('useFrontmatter', useFM);
  }

  static bool getFrontmatterSupport() {
    return App.localStorage.getBool('useFrontmatter') ?? false;
  }
}

// For Editor settings

class UserEditorConfig {
  static void setFontSize(double fontSize) {
    App.localStorage.setDouble('editorConfigFontSize', fontSize);
  }

  static double getFontSize() {
    return App.localStorage.getDouble('editorConfigFontSize') ?? 16;
  }

  // static void setToolbarConfig(String config)  {
  //
  //   App.localStorage.setString('toolbar_config', config);
  // }

  // static String? getToolbarConfig()  {
  //
  //   return App.localStorage.getString('toolbar_config');
  // }
}
