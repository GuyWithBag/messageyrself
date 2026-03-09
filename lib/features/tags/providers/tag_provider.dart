// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/tags/providers/tag_provider.dart
// PURPOSE: Manages tag list, counts, creation and deletion
// PROVIDERS: TagProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../services/hive_service.dart';
import '../models/tag.dart';

/// Manages the full tag list and keeps message counts in sync.
///
/// [ChatProvider] calls [incrementCount] / [decrementCount] when
/// messages are sent or deleted.
class TagProvider extends ChangeNotifier {
  final HiveService _hiveService;

  List<Tag> _tags = [];
  bool _isLoading = false;
  String? _error;

  TagProvider(this._hiveService);

  List<Tag> get tags => List.unmodifiable(_tags);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Loads all tags sorted alphabetically by label.
  Future<void> loadTags() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tags = _hiveService.tagsBox.values.toList()
        ..sort((a, b) => a.label.compareTo(b.label));
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a tag if one with [label] doesn't already exist.
  Future<Tag> createTag(String label) async {
    final existing = _tags.where(
      (t) => t.label.toLowerCase() == label.toLowerCase(),
    );
    if (existing.isNotEmpty) return existing.first;

    final tag = Tag.create(
      label: label.toLowerCase(),
      colorArgb: _pickColor(label),
    );

    try {
      await _hiveService.tagsBox.put(tag.id, tag);
      _tags.add(tag);
      _tags.sort((a, b) => a.label.compareTo(b.label));
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return tag;
  }

  /// Permanently deletes a tag from Hive.
  Future<void> deleteTag(String id) async {
    try {
      await _hiveService.tagsBox.delete(id);
      _tags.removeWhere((t) => t.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Increments the message count for the tag with [label].
  ///
  /// Creates the tag if it doesn't exist.
  Future<void> incrementCount(String label) async {
    final idx = _tags.indexWhere(
      (t) => t.label.toLowerCase() == label.toLowerCase(),
    );

    if (idx == -1) {
      await createTag(label);
      return;
    }

    final updated = _tags[idx].copyWith(
      messageCount: _tags[idx].messageCount + 1,
    );
    await _hiveService.tagsBox.put(updated.id, updated);
    _tags[idx] = updated;
    notifyListeners();
  }

  /// Decrements the message count for the tag with [label].
  ///
  /// Removes the tag from Hive when count reaches 0.
  Future<void> decrementCount(String label) async {
    final idx = _tags.indexWhere(
      (t) => t.label.toLowerCase() == label.toLowerCase(),
    );
    if (idx == -1) return;

    final newCount = _tags[idx].messageCount - 1;
    if (newCount <= 0) {
      await deleteTag(_tags[idx].id);
      return;
    }

    final updated = _tags[idx].copyWith(messageCount: newCount);
    await _hiveService.tagsBox.put(updated.id, updated);
    _tags[idx] = updated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Private helpers ─────────────────────────────

  static const _kTagColors = [
    0xFF0A7CFF, 0xFF833AB4, 0xFF25D366, 0xFFE91E63,
    0xFFFF9800, 0xFF009688, 0xFF607D8B, 0xFFF44336,
  ];

  int _pickColor(String label) {
    final r = Random(label.hashCode);
    return _kTagColors[r.nextInt(_kTagColors.length)];
  }
}
