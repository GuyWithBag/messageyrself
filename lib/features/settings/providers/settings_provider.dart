// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/providers/settings_provider.dart
// PURPOSE: Manages app settings, preset resolution, and theme generation
// PROVIDERS: SettingsProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/layout_preset.dart';
import '../../../core/theme/presets/default_preset.dart';
import '../../../core/theme/presets/instagram_preset.dart';
import '../../../core/theme/presets/messenger_preset.dart';
import '../../../core/theme/presets/whatsapp_preset.dart';
import '../../../services/hive_service.dart';
import '../models/app_settings.dart';
import '../models/user_preset.dart';

/// Manages app settings, active preset, user presets, and theme generation.
///
/// Watches [HiveService] for persistence. Resolves the active preset
/// (built-in or user) and builds [ThemeData] via [AppTheme].
class SettingsProvider extends ChangeNotifier {
  final HiveService _hiveService;

  AppSettings _settings = AppSettings();
  List<UserPreset> _userPresets = [];
  bool _isLoading = false;
  String? _error;

  SettingsProvider(this._hiveService);

  AppSettings get settings => _settings;
  List<UserPreset> get userPresets => List.unmodifiable(_userPresets);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// The currently active [LayoutPreset] resolved from settings.
  LayoutPreset get activePreset => _resolvePreset(_settings.activePresetId);

  /// Light [ThemeData] built from the active preset tokens.
  ThemeData get lightTheme =>
      AppTheme.light(activePreset, _settings.fontFamily);

  /// Dark [ThemeData] built from the active preset tokens.
  ThemeData get darkTheme => AppTheme.dark(activePreset, _settings.fontFamily);

  /// The current [ThemeMode] parsed from settings.
  ThemeMode get themeMode => switch (_settings.themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  /// Loads settings and user presets from Hive. Writes defaults on first launch.
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = _hiveService.settingsBox;
      _settings = box.get('app_settings') ?? AppSettings();
      if (!box.containsKey('app_settings')) {
        await box.put('app_settings', _settings);
      }

      _userPresets = _hiveService.userPresetsBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Switches to a built-in preset by key.
  Future<void> applyBuiltInPreset(String key) async {
    try {
      final preset = _resolveBuiltIn(key);
      _settings = _settings.copyWith(
        activePresetId: preset.id,
        primaryColorArgb: preset.primaryColorArgb,
        accentColorArgb: preset.accentColorArgb,
        bubbleRadius: preset.bubbleRadius,
        wallpaperType: preset.wallpaperType,
        wallpaperValue: preset.wallpaperValue,
      );
      await _save();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Switches to a user-saved preset by id.
  Future<void> applyUserPreset(String id) async {
    try {
      final up = _userPresets.firstWhere((p) => p.id == id);
      _settings = _settings.copyWith(
        activePresetId: up.id,
        primaryColorArgb: up.primaryColorArgb,
        accentColorArgb: up.accentColorArgb,
        bubbleRadius: up.bubbleRadius,
        wallpaperType: up.wallpaperType,
        wallpaperValue: up.wallpaperValue,
        fontFamily: up.fontFamily,
        fontSize: up.fontSize,
      );
      await _save();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> setPrimaryColor(Color color) async {
    _settings = _settings.copyWith(primaryColorArgb: color.toARGB32());
    await _save();
  }

  Future<void> setAccentColor(Color color) async {
    _settings = _settings.copyWith(accentColorArgb: color.toARGB32());
    await _save();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    _settings = _settings.copyWith(themeMode: value);
    await _save();
  }

  Future<void> setFontFamily(String fontFamily) async {
    _settings = _settings.copyWith(fontFamily: fontFamily);
    await _save();
  }

  Future<void> setFontSize(String fontSize) async {
    _settings = _settings.copyWith(fontSize: fontSize);
    await _save();
  }

  Future<void> setBubbleRadius(double radius) async {
    _settings = _settings.copyWith(bubbleRadius: radius);
    await _save();
  }

  Future<void> setWallpaper(String type, String? value) async {
    _settings = _settings.copyWith(
      wallpaperType: type,
      wallpaperValue: value,
    );
    await _save();
  }

  /// Saves the current token state as a named user preset.
  Future<void> saveCurrentAsUserPreset(
    String name,
    String? thumbnailData,
  ) async {
    try {
      final preset = UserPreset.create(
        name: name,
        basePresetId: _settings.activePresetId,
        fontFamily: _settings.fontFamily,
        fontSize: _settings.fontSize,
        primaryColorArgb: _settings.primaryColorArgb,
        accentColorArgb: _settings.accentColorArgb,
        bubbleRadius: _settings.bubbleRadius,
        wallpaperType: _settings.wallpaperType,
        wallpaperValue: _settings.wallpaperValue,
        thumbnailData: thumbnailData,
      );
      await _hiveService.userPresetsBox.put(preset.id, preset);
      _userPresets = _hiveService.userPresetsBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Deletes a user preset. Falls back to 'default' if it was active.
  Future<void> deleteUserPreset(String id) async {
    try {
      await _hiveService.userPresetsBox.delete(id);
      _userPresets.removeWhere((p) => p.id == id);
      if (_settings.activePresetId == id) {
        await applyBuiltInPreset('default');
        return;
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

  Future<void> _save() async {
    try {
      await _hiveService.settingsBox.put('app_settings', _settings);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  LayoutPreset _resolvePreset(String id) {
    final builtIn = _tryResolveBuiltIn(id);
    if (builtIn != null) return builtIn;

    final userPreset = _userPresets.where((p) => p.id == id).firstOrNull;
    if (userPreset != null) return _userPresetToLayout(userPreset);

    return defaultPreset;
  }

  LayoutPreset? _tryResolveBuiltIn(String key) => switch (key) {
        'default' => defaultPreset,
        'messenger' => messengerPreset,
        'instagram' => instagramPreset,
        'whatsapp' => whatsappPreset,
        _ => null,
      };

  LayoutPreset _resolveBuiltIn(String key) {
    return _tryResolveBuiltIn(key) ?? defaultPreset;
  }

  LayoutPreset _userPresetToLayout(UserPreset up) {
    final base = _resolveBuiltIn(up.basePresetId);
    return LayoutPreset(
      id: up.id,
      displayName: up.name,
      isBuiltIn: false,
      primaryColorArgb: up.primaryColorArgb,
      accentColorArgb: up.accentColorArgb,
      sentBubbleColorArgb: base.sentBubbleColorArgb,
      receivedBubbleColorArgb: base.receivedBubbleColorArgb,
      sentBubbleTextColorArgb: base.sentBubbleTextColorArgb,
      receivedBubbleTextColorArgb: base.receivedBubbleTextColorArgb,
      bubbleRadius: up.bubbleRadius,
      hasBubbleTail: base.hasBubbleTail,
      hasGradientBubble: base.hasGradientBubble,
      gradientColors: base.gradientColors,
      inputBarStyle: base.inputBarStyle,
      navStyle: base.navStyle,
      wallpaperType: up.wallpaperType,
      wallpaperValue: up.wallpaperValue,
      fontFamily: up.fontFamily,
      appBarColorArgb: base.appBarColorArgb,
      appBarForegroundArgb: base.appBarForegroundArgb,
    );
  }
}
