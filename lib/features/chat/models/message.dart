// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/models/message.dart
// PURPOSE: Chat message data model persisted in Hive
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

import 'package:hive_ce/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  final String id;
  final String sessionId;
  final String? content;
  final String? voicePath;
  final int? voiceDurationMs;
  final List<String> tags;
  final bool isSent;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sessionId,
    this.content,
    this.voicePath,
    this.voiceDurationMs,
    this.tags = const [],
    required this.isSent,
    required this.createdAt,
  });

  factory Message.create({
    required String sessionId,
    String? content,
    String? voicePath,
    int? voiceDurationMs,
    List<String> tags = const [],
    required bool isSent,
  }) {
    return Message(
      id: _generateId(),
      sessionId: sessionId,
      content: content,
      voicePath: voicePath,
      voiceDurationMs: voiceDurationMs,
      tags: tags,
      isSent: isSent,
      createdAt: DateTime.now(),
    );
  }

  Message copyWith({
    String? id,
    String? sessionId,
    String? content,
    String? voicePath,
    int? voiceDurationMs,
    List<String>? tags,
    bool? isSent,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      content: content ?? this.content,
      voicePath: voicePath ?? this.voicePath,
      voiceDurationMs: voiceDurationMs ?? this.voiceDurationMs,
      tags: tags ?? this.tags,
      isSent: isSent ?? this.isSent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Message(id: $id, sessionId: $sessionId, isSent: $isSent, '
      'content: ${content?.substring(0, content!.length.clamp(0, 30))})';

  static String _generateId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
