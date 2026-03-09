// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/models/session.dart
// PURPOSE: Chat session data model persisted in Hive
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

class Session {
  final String id;
  final String notebookId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;

  Session({
    required this.id,
    required this.notebookId,
    this.title = 'New Session',
    required this.createdAt,
    required this.updatedAt,
    this.messageCount = 0,
  });

  factory Session.create({
    required String notebookId,
    String title = 'New Session',
  }) {
    final now = DateTime.now();
    return Session(
      id: _generateId(),
      notebookId: notebookId,
      title: title,
      createdAt: now,
      updatedAt: now,
    );
  }

  Session copyWith({
    String? id,
    String? notebookId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
  }) {
    return Session(
      id: id ?? this.id,
      notebookId: notebookId ?? this.notebookId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Session(id: $id, notebookId: $notebookId, title: $title, '
      'messageCount: $messageCount)';

  static String _generateId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
