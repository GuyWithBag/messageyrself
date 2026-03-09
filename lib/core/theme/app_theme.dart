// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/app_theme.dart
// PURPOSE: Builds ThemeData from LayoutPreset tokens + settings
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_spacing.dart';
import 'layout_preset.dart';
import 'theme_extensions/bubble_theme.dart';
import 'theme_extensions/input_bar_theme.dart';
import 'theme_extensions/nav_theme_extension.dart';

/// Builds light and dark [ThemeData] from a resolved [LayoutPreset].
///
/// Attaches [BubbleTheme], [InputBarTheme], and [NavThemeExtension]
/// so widgets can read tokens via `Theme.of(context).extension<T>()!`.
abstract final class AppTheme {
  static ThemeData light(LayoutPreset preset, String fontFamily) {
    return _build(preset, fontFamily, Brightness.light);
  }

  static ThemeData dark(LayoutPreset preset, String fontFamily) {
    return _build(preset, fontFamily, Brightness.dark);
  }

  static ThemeData _build(
    LayoutPreset preset,
    String fontFamily,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    final primary = Color(preset.primaryColorArgb);
    final accent = Color(preset.accentColorArgb);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? colorScheme.surface
            : Color(preset.appBarColorArgb),
        foregroundColor: isDark
            ? colorScheme.onSurface
            : Color(preset.appBarForegroundArgb),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: accent.withAlpha(30),
        labelBehavior: _navLabelBehavior(preset.navStyle),
      ),
      extensions: [
        BubbleTheme(
          sentBubbleColor: Color(preset.sentBubbleColorArgb),
          receivedBubbleColor: Color(preset.receivedBubbleColorArgb),
          sentBubbleTextColor: Color(preset.sentBubbleTextColorArgb),
          receivedBubbleTextColor: Color(preset.receivedBubbleTextColorArgb),
          bubbleRadius: preset.bubbleRadius,
          hasBubbleTail: preset.hasBubbleTail,
          hasGradientBubble: preset.hasGradientBubble,
          gradientColors: preset.gradientColors,
        ),
        InputBarTheme(
          style: preset.inputBarStyle,
          height: preset.inputBarStyle == InputBarStyle.thin
              ? AppSpacing.inputBarThinHeight
              : AppSpacing.inputBarHeight,
          accentColor: accent,
        ),
        NavThemeExtension(
          navStyle: preset.navStyle,
          activeIndicatorColor: accent,
          showLabels: preset.navStyle != NavStyle.iconOnly,
        ),
      ],
    );
  }

  static NavigationDestinationLabelBehavior _navLabelBehavior(NavStyle style) {
    return switch (style) {
      NavStyle.iconOnly => NavigationDestinationLabelBehavior.alwaysHide,
      _ => NavigationDestinationLabelBehavior.alwaysShow,
    };
  }
}
