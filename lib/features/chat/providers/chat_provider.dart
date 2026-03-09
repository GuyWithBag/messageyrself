// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/providers/chat_provider.dart
// PURPOSE: Manages messages for the active chat session
// PROVIDERS: ChatProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';

import '../../../core/utils/tag_parser.dart';
import '../../../services/hive_service.dart';
import '../../tags/providers/tag_provider.dart';
import '../models/message.dart';
import '../models/session.dart';

/// Manages the message list for the currently active session.
///
/// Handles sending text/voice messages, parsing #tags, and deletion.
/// Delegates tag count updates to [TagProvider].
class ChatProvider extends ChangeNotifier {
  final HiveService _hiveService;
  final TagProvider _tagProvider;

  List<Message> _messages = [];
  String? _activeSessionId;
  bool _isLoading = false;
  String? _error;

  ChatProvider(this._hiveService, this._tagProvider);

  List<Message> get messages => List.unmodifiable(_messages);
  String? get activeSessionId => _activeSessionId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Loads all messages for [sessionId], sorted by createdAt ascending.
  ///
  /// Creates a default session if 'default' is requested and doesn't exist.
  Future<void> loadSession(String sessionId) async {
    _isLoading = true;
    _activeSessionId = sessionId;
    notifyListeners();

    try {
      if (sessionId == 'default') {
        await _ensureDefaultSession();
      }

      _messages = _hiveService.messagesBox.values
          .where((m) => m.sessionId == sessionId)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends a text message, parses #tags, and persists to Hive.
  Future<void> sendMessage(String content) async {
    if (_activeSessionId == null || content.trim().isEmpty) return;

    try {
      final tags = TagParser.extractTags(content);
      final message = Message.create(
        sessionId: _activeSessionId!,
        content: content.trim(),
        tags: tags,
        isSent: true,
      );

      await _hiveService.messagesBox.put(message.id, message);
      _messages.add(message);
      await _updateSessionTimestamp();
      for (final tag in tags) {
        await _tagProvider.incrementCount(tag);
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Sends a voice message with file path and duration.
  Future<void> sendVoiceMessage(String path, Duration duration) async {
    if (_activeSessionId == null) return;

    try {
      final message = Message.create(
        sessionId: _activeSessionId!,
        voicePath: path,
        voiceDurationMs: duration.inMilliseconds,
        isSent: true,
      );

      await _hiveService.messagesBox.put(message.id, message);
      _messages.add(message);
      await _updateSessionTimestamp();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Deletes a message by id from Hive and the local list.
  ///
  /// Decrements tag counts for all tags on the deleted message.
  Future<void> deleteMessage(String id) async {
    try {
      final msg = _messages.where((m) => m.id == id).firstOrNull;
      await _hiveService.messagesBox.delete(id);
      _messages.removeWhere((m) => m.id == id);
      if (msg != null) {
        for (final tag in msg.tags) {
          await _tagProvider.decrementCount(tag);
        }
      }
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

  Future<void> _ensureDefaultSession() async {
    final sessions = _hiveService.sessionsBox.values;
    final hasDefault = sessions.any((s) => s.id == 'default');
    if (!hasDefault) {
      final session = Session(
        id: 'default',
        notebookId: 'default',
        title: 'My Notes',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _hiveService.sessionsBox.put(session.id, session);
    }
  }

  Future<void> _updateSessionTimestamp() async {
    if (_activeSessionId == null) return;
    final session = _hiveService.sessionsBox.get(_activeSessionId);
    if (session != null) {
      final updated = Session(
        id: session.id,
        notebookId: session.notebookId,
        title: session.title,
        createdAt: session.createdAt,
        updatedAt: DateTime.now(),
        messageCount: _messages.length,
      );
      await _hiveService.sessionsBox.put(session.id, updated);
    }
  }
}
