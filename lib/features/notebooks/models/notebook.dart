// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/notebooks/models/notebook.dart
// PURPOSE: Notebook data model persisted in Hive
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

class Notebook {
  final String id;
  final String title;
  final int colorArgb;
  final DateTime createdAt;
  final int sessionCount;

  Notebook({
    required this.id,
    required this.title,
    required this.colorArgb,
    required this.createdAt,
    this.sessionCount = 0,
  });

  factory Notebook.create({
    required String title,
    required int colorArgb,
  }) {
    return Notebook(
      id: _generateId(),
      title: title,
      colorArgb: colorArgb,
      createdAt: DateTime.now(),
    );
  }

  Notebook copyWith({
    String? id,
    String? title,
    int? colorArgb,
    DateTime? createdAt,
    int? sessionCount,
  }) {
    return Notebook(
      id: id ?? this.id,
      title: title ?? this.title,
      colorArgb: colorArgb ?? this.colorArgb,
      createdAt: createdAt ?? this.createdAt,
      sessionCount: sessionCount ?? this.sessionCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notebook && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Notebook(id: $id, title: $title, sessionCount: $sessionCount)';

  static String _generateId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
