// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/models/app_settings.dart
// PURPOSE: App settings model stored as single object in Hive
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import '../../../core/constants/app_colors.dart';

class AppSettings {
  final String activePresetId;
  final String themeMode;
  final String fontFamily;
  final String fontSize;
  final int primaryColorArgb;
  final int accentColorArgb;
  final double bubbleRadius;
  final String wallpaperType;
  final String? wallpaperValue;

  AppSettings({
    this.activePresetId = 'default',
    this.themeMode = 'system',
    this.fontFamily = 'Rubik',
    this.fontSize = 'medium',
    int? primaryColorArgb,
    int? accentColorArgb,
    this.bubbleRadius = 1.0,
    this.wallpaperType = 'none',
    this.wallpaperValue,
  })  : primaryColorArgb =
            primaryColorArgb ?? AppColors.defaultPrimary.toARGB32(),
        accentColorArgb =
            accentColorArgb ?? AppColors.defaultPrimary.toARGB32();

  AppSettings copyWith({
    String? activePresetId,
    String? themeMode,
    String? fontFamily,
    String? fontSize,
    int? primaryColorArgb,
    int? accentColorArgb,
    double? bubbleRadius,
    String? wallpaperType,
    String? wallpaperValue,
  }) {
    return AppSettings(
      activePresetId: activePresetId ?? this.activePresetId,
      themeMode: themeMode ?? this.themeMode,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      primaryColorArgb: primaryColorArgb ?? this.primaryColorArgb,
      accentColorArgb: accentColorArgb ?? this.accentColorArgb,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
      wallpaperType: wallpaperType ?? this.wallpaperType,
      wallpaperValue: wallpaperValue ?? this.wallpaperValue,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          activePresetId == other.activePresetId &&
          themeMode == other.themeMode &&
          fontFamily == other.fontFamily &&
          fontSize == other.fontSize &&
          primaryColorArgb == other.primaryColorArgb &&
          accentColorArgb == other.accentColorArgb &&
          bubbleRadius == other.bubbleRadius &&
          wallpaperType == other.wallpaperType &&
          wallpaperValue == other.wallpaperValue;

  @override
  int get hashCode => Object.hash(
        activePresetId,
        themeMode,
        fontFamily,
        fontSize,
        primaryColorArgb,
        accentColorArgb,
        bubbleRadius,
        wallpaperType,
        wallpaperValue,
      );

  @override
  String toString() =>
      'AppSettings(preset: $activePresetId, theme: $themeMode, '
      'font: $fontFamily/$fontSize)';
}
