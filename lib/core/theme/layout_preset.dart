// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/layout_preset.dart
// PURPOSE: LayoutPreset data class and related enums for preset system
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

enum InputBarStyle { pill, flat, thin }

enum NavStyle { labeledBottom, iconOnly, greenBottom }

class LayoutPreset {
  final String id;
  final String displayName;
  final bool isBuiltIn;
  final int primaryColorArgb;
  final int accentColorArgb;
  final int sentBubbleColorArgb;
  final int receivedBubbleColorArgb;
  final int sentBubbleTextColorArgb;
  final int receivedBubbleTextColorArgb;
  final double bubbleRadius;
  final bool hasBubbleTail;
  final bool hasGradientBubble;
  final List<Color>? gradientColors;
  final InputBarStyle inputBarStyle;
  final NavStyle navStyle;
  final String wallpaperType;
  final String? wallpaperValue;
  final String fontFamily;
  final int appBarColorArgb;
  final int appBarForegroundArgb;

  const LayoutPreset({
    required this.id,
    required this.displayName,
    required this.isBuiltIn,
    required this.primaryColorArgb,
    required this.accentColorArgb,
    required this.sentBubbleColorArgb,
    required this.receivedBubbleColorArgb,
    required this.sentBubbleTextColorArgb,
    required this.receivedBubbleTextColorArgb,
    this.bubbleRadius = 1.0,
    this.hasBubbleTail = false,
    this.hasGradientBubble = false,
    this.gradientColors,
    this.inputBarStyle = InputBarStyle.pill,
    this.navStyle = NavStyle.labeledBottom,
    this.wallpaperType = 'none',
    this.wallpaperValue,
    this.fontFamily = 'Rubik',
    required this.appBarColorArgb,
    required this.appBarForegroundArgb,
  });
}
