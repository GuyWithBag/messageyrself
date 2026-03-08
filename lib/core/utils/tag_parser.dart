// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/utils/tag_parser.dart
// PURPOSE: Extracts #hashtags from message content
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class TagParser {
  static final _tagPattern = RegExp(r'#(\w+)');

  /// Extracts unique lowercase tag labels from [content].
  ///
  /// Returns an empty list if no tags are found.
  /// Tags are de-duplicated and lowercased.
  static List<String> extractTags(String content) {
    final matches = _tagPattern.allMatches(content);
    final tags = <String>{};
    for (final match in matches) {
      final tag = match.group(1);
      if (tag != null && tag.isNotEmpty) {
        tags.add(tag.toLowerCase());
      }
    }
    return tags.toList();
  }
}
