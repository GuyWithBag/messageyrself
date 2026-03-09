// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/notebooks/providers/notebook_provider.dart
// PURPOSE: Manages notebook list, sessions per notebook, creation and deletion
// PROVIDERS: NotebookProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../services/hive_service.dart';
import '../../chat/models/session.dart';
import '../models/notebook.dart';

/// Manages the full notebook list and their associated sessions.
///
/// Sessions are grouped by notebookId. The default notebook ('default')
/// is created automatically on first load if it doesn't exist.
class NotebookProvider extends ChangeNotifier {
  final HiveService _hiveService;

  List<Notebook> _notebooks = [];
  bool _isLoading = false;
  String? _error;

  NotebookProvider(this._hiveService);

  List<Notebook> get notebooks => List.unmodifiable(_notebooks);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns sessions belonging to [notebookId], sorted by updatedAt descending.
  List<Session> sessionsFor(String notebookId) {
    return _hiveService.sessionsBox.values
        .where((s) => s.notebookId == notebookId)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Loads all notebooks sorted alphabetically.
  ///
  /// Creates a default notebook if none exists.
  Future<void> loadNotebooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _ensureDefaultNotebook();
      _notebooks = _hiveService.notebooksBox.values.toList()
        ..sort((a, b) => a.title.compareTo(b.title));
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new notebook with [title] and [colorArgb].
  Future<void> createNotebook({
    required String title,
    required int colorArgb,
  }) async {
    final notebook = Notebook.create(title: title, colorArgb: colorArgb);

    try {
      await _hiveService.notebooksBox.put(notebook.id, notebook);
      _notebooks.add(notebook);
      _notebooks.sort((a, b) => a.title.compareTo(b.title));
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Creates a new session inside [notebookId] with [title].
  Future<Session> createSession({
    required String notebookId,
    required String title,
  }) async {
    final session = Session(
      id: _generateId(),
      notebookId: notebookId,
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _hiveService.sessionsBox.put(session.id, session);
    await _incrementSessionCount(notebookId);
    notifyListeners();
    return session;
  }

  /// Deletes a session by [sessionId] and decrements the notebook's count.
  Future<void> deleteSession(String sessionId) async {
    final session = _hiveService.sessionsBox.get(sessionId);
    try {
      // Delete all messages for this session
      final messageKeys = _hiveService.messagesBox.values
          .where((m) => m.sessionId == sessionId)
          .map((m) => m.id)
          .toList();
      for (final key in messageKeys) {
        await _hiveService.messagesBox.delete(key);
      }
      await _hiveService.sessionsBox.delete(sessionId);
      if (session != null) {
        await _decrementSessionCount(session.notebookId);
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Deletes a notebook and all its sessions and messages.
  Future<void> deleteNotebook(String id) async {
    try {
      final sessions = sessionsFor(id);
      for (final session in sessions) {
        await deleteSession(session.id);
      }
      await _hiveService.notebooksBox.delete(id);
      _notebooks.removeWhere((n) => n.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Private helpers ─────────────────────────────

  Future<void> _ensureDefaultNotebook() async {
    final hasDefault =
        _hiveService.notebooksBox.values.any((n) => n.id == 'default');
    if (!hasDefault) {
      final notebook = Notebook(
        id: 'default',
        title: 'My Notebook',
        colorArgb: 0xFF0A7CFF,
        createdAt: DateTime.now(),
      );
      await _hiveService.notebooksBox.put(notebook.id, notebook);
    }
  }

  Future<void> _incrementSessionCount(String notebookId) async {
    final notebook = _hiveService.notebooksBox.get(notebookId);
    if (notebook == null) return;
    final updated =
        notebook.copyWith(sessionCount: notebook.sessionCount + 1);
    await _hiveService.notebooksBox.put(notebookId, updated);
    final idx = _notebooks.indexWhere((n) => n.id == notebookId);
    if (idx != -1) _notebooks[idx] = updated;
  }

  Future<void> _decrementSessionCount(String notebookId) async {
    final notebook = _hiveService.notebooksBox.get(notebookId);
    if (notebook == null) return;
    final newCount = (notebook.sessionCount - 1).clamp(0, double.maxFinite.toInt());
    final updated = notebook.copyWith(sessionCount: newCount);
    await _hiveService.notebooksBox.put(notebookId, updated);
    final idx = _notebooks.indexWhere((n) => n.id == notebookId);
    if (idx != -1) _notebooks[idx] = updated;
  }

  static String _generateId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
