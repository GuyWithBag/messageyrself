// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/presets/messenger_preset.dart
// PURPOSE: Facebook Messenger faithful approximation preset
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import '../layout_preset.dart';

const messengerPreset = LayoutPreset(
  id: 'messenger',
  displayName: 'Messenger',
  isBuiltIn: true,
  primaryColorArgb: 0xFF0084FF,
  accentColorArgb: 0xFF0084FF,
  sentBubbleColorArgb: 0xFF0084FF,
  receivedBubbleColorArgb: 0xFFF0F0F0,
  sentBubbleTextColorArgb: 0xFFFFFFFF,
  receivedBubbleTextColorArgb: 0xFF000000,
  bubbleRadius: 1.0,
  inputBarStyle: InputBarStyle.pill,
  navStyle: NavStyle.iconOnly,
  appBarColorArgb: 0xFFFFFFFF,
  appBarForegroundArgb: 0xFF000000,
);
