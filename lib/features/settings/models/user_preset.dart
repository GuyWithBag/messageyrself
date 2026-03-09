// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/models/user_preset.dart
// PURPOSE: User-saved preset model persisted in Hive
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';

class UserPreset {
  final String id;
  final String name;
  final DateTime createdAt;
  final String basePresetId;
  final String fontFamily;
  final String fontSize;
  final int primaryColorArgb;
  final int accentColorArgb;
  final double bubbleRadius;
  final String wallpaperType;
  final String? wallpaperValue;
  final String? thumbnailData;

  UserPreset({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.basePresetId,
    required this.fontFamily,
    required this.fontSize,
    required this.primaryColorArgb,
    required this.accentColorArgb,
    required this.bubbleRadius,
    this.wallpaperType = 'none',
    this.wallpaperValue,
    this.thumbnailData,
  });

  factory UserPreset.create({
    required String name,
    required String basePresetId,
    required String fontFamily,
    required String fontSize,
    required int primaryColorArgb,
    required int accentColorArgb,
    required double bubbleRadius,
    String wallpaperType = 'none',
    String? wallpaperValue,
    String? thumbnailData,
  }) {
    return UserPreset(
      id: _generateId(),
      name: name,
      createdAt: DateTime.now(),
      basePresetId: basePresetId,
      fontFamily: fontFamily,
      fontSize: fontSize,
      primaryColorArgb: primaryColorArgb,
      accentColorArgb: accentColorArgb,
      bubbleRadius: bubbleRadius,
      wallpaperType: wallpaperType,
      wallpaperValue: wallpaperValue,
      thumbnailData: thumbnailData,
    );
  }

  UserPreset copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? basePresetId,
    String? fontFamily,
    String? fontSize,
    int? primaryColorArgb,
    int? accentColorArgb,
    double? bubbleRadius,
    String? wallpaperType,
    String? wallpaperValue,
    String? thumbnailData,
  }) {
    return UserPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      basePresetId: basePresetId ?? this.basePresetId,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      primaryColorArgb: primaryColorArgb ?? this.primaryColorArgb,
      accentColorArgb: accentColorArgb ?? this.accentColorArgb,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
      wallpaperType: wallpaperType ?? this.wallpaperType,
      wallpaperValue: wallpaperValue ?? this.wallpaperValue,
      thumbnailData: thumbnailData ?? this.thumbnailData,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreset &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'UserPreset(id: $id, name: $name, base: $basePresetId)';

  static String _generateId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
