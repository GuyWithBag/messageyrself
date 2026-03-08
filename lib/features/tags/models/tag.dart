// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/tags/models/tag.dart
// PURPOSE: Tag data model persisted in Hive
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

import 'package:hive_ce/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 2)
class Tag extends HiveObject {
  final String id;
  final String label;
  final int colorArgb;
  final int messageCount;
  final DateTime createdAt;

  Tag({
    required this.id,
    required this.label,
    required this.colorArgb,
    this.messageCount = 0,
    required this.createdAt,
  });

  factory Tag.create({
    required String label,
    required int colorArgb,
  }) {
    return Tag(
      id: _generateId(),
      label: label,
      colorArgb: colorArgb,
      createdAt: DateTime.now(),
    );
  }

  Tag copyWith({
    String? id,
    String? label,
    int? colorArgb,
    int? messageCount,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      label: label ?? this.label,
      colorArgb: colorArgb ?? this.colorArgb,
      messageCount: messageCount ?? this.messageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Tag(id: $id, label: $label, messageCount: $messageCount)';

  static String _generateId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
