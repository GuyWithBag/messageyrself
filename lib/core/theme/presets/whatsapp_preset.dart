// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/presets/whatsapp_preset.dart
// PURPOSE: WhatsApp faithful approximation preset
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import '../layout_preset.dart';

const whatsappPreset = LayoutPreset(
  id: 'whatsapp',
  displayName: 'WhatsApp',
  isBuiltIn: true,
  primaryColorArgb: 0xFF25D366,
  accentColorArgb: 0xFF25D366,
  sentBubbleColorArgb: 0xFFDCF8C6,
  receivedBubbleColorArgb: 0xFFFFFFFF,
  sentBubbleTextColorArgb: 0xFF000000,
  receivedBubbleTextColorArgb: 0xFF000000,
  bubbleRadius: 0.6,
  hasBubbleTail: true,
  inputBarStyle: InputBarStyle.flat,
  navStyle: NavStyle.greenBottom,
  wallpaperType: 'color',
  wallpaperValue: '0xFFE5DDD5',
  appBarColorArgb: 0xFF075E54,
  appBarForegroundArgb: 0xFFFFFFFF,
);
