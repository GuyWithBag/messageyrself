// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/presets/default_preset.dart
// PURPOSE: MessageYrself native default preset
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import '../layout_preset.dart';

const defaultPreset = LayoutPreset(
  id: 'default',
  displayName: 'MessageYrself',
  isBuiltIn: true,
  primaryColorArgb: 0xFF0A7CFF,
  accentColorArgb: 0xFF0A7CFF,
  sentBubbleColorArgb: 0xFFFFFFFF,
  receivedBubbleColorArgb: 0xFFE5E5EA,
  sentBubbleTextColorArgb: 0xFF0A7CFF,
  receivedBubbleTextColorArgb: 0xFF000000,
  bubbleRadius: 1.0,
  inputBarStyle: InputBarStyle.pill,
  navStyle: NavStyle.labeledBottom,
  appBarColorArgb: 0xFF000000,
  appBarForegroundArgb: 0xFFFFFFFF,
);
