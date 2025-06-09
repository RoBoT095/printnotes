import 'package:cosmic_frontmatter/cosmic_frontmatter.dart';

class FrontmatterHandleParsing {
  /// Pass markdown data and get access to frontmatter tags
  ///
  ///     handler.getParsedData(fileAsString).frontmatter['title'] // -> 'markdown title' or null
  ///
  /// or just get plain body without the frontmatter syntax
  ///
  ///     handler.getParsedData(fileAsString).body
  static Document? getParsedData(String content) {
    Document? doc;
    try {
      doc = parseFrontmatter(
        content: content,
        frontmatterBuilder: (map) => map,
      );
    } catch (e) {
      doc = null;
    }
    return doc;
  }

  /// Get just the data from the a tag to avoid having too many
  /// null checks from parsed [Document] and desired tag when
  /// only using [getParsedData]
  ///
  ///     f.getTagString(fileAsString, 'title') // -> 'markdown title' or null
  static String? getTagString(String content, String tag) {
    String? tagData;
    final Document? doc = getParsedData(content);

    try {
      if (doc != null) tagData = doc.frontmatter[tag];
    } catch (e) {
      tagData = null;
    }
    return tagData;
  }
}
