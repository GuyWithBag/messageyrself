// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/presets/instagram_preset.dart
// PURPOSE: Instagram DMs faithful approximation preset
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

import '../layout_preset.dart';

const instagramPreset = LayoutPreset(
  id: 'instagram',
  displayName: 'Instagram',
  isBuiltIn: true,
  primaryColorArgb: 0xFF833AB4,
  accentColorArgb: 0xFFFD1D1D,
  sentBubbleColorArgb: 0xFF833AB4,
  receivedBubbleColorArgb: 0xFFEFEFEF,
  sentBubbleTextColorArgb: 0xFFFFFFFF,
  receivedBubbleTextColorArgb: 0xFF000000,
  bubbleRadius: 1.0,
  hasGradientBubble: true,
  gradientColors: [
    Color(0xFF833AB4),
    Color(0xFFFD1D1D),
    Color(0xFFF77737),
  ],
  inputBarStyle: InputBarStyle.thin,
  navStyle: NavStyle.iconOnly,
  appBarColorArgb: 0xFFFFFFFF,
  appBarForegroundArgb: 0xFF000000,
);
