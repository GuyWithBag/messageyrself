// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/constants/app_colors.dart
// PURPOSE: Centralized color constants for the app
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

abstract final class AppColors {
  // Default preset
  static const defaultPrimary = Color(0xFF0A7CFF);
  static const defaultSentBubble = Color(0xFFFFFFFF);
  static const defaultSentBubbleText = Color(0xFF0A7CFF);
  static const defaultReceivedBubble = Color(0xFFE5E5EA);
  static const defaultReceivedBubbleText = Color(0xFF000000);
  static const defaultAppBar = Color(0xFF000000);
  static const defaultAppBarForeground = Color(0xFFFFFFFF);

  // Messenger preset
  static const messengerPrimary = Color(0xFF0084FF);
  static const messengerSentBubble = Color(0xFF0084FF);
  static const messengerSentBubbleText = Color(0xFFFFFFFF);
  static const messengerReceivedBubbleLight = Color(0xFFF0F0F0);
  static const messengerReceivedBubbleDark = Color(0xFF3A3A3C);
  static const messengerReceivedBubbleText = Color(0xFF000000);
  static const messengerAppBarLight = Color(0xFFFFFFFF);
  static const messengerAppBarDark = Color(0xFF1C1C1E);

  // Instagram preset
  static const instagramGradientStart = Color(0xFF833AB4);
  static const instagramGradientMid = Color(0xFFFD1D1D);
  static const instagramGradientEnd = Color(0xFFF77737);
  static const instagramReceivedBubbleLight = Color(0xFFEFEFEF);
  static const instagramReceivedBubbleDark = Color(0xFF262626);

  // WhatsApp preset
  static const whatsappPrimary = Color(0xFF25D366);
  static const whatsappAppBar = Color(0xFF075E54);
  static const whatsappAppBarDark = Color(0xFF1F2C34);
  static const whatsappSentBubbleLight = Color(0xFFDCF8C6);
  static const whatsappSentBubbleDark = Color(0xFF056162);
  static const whatsappReceivedBubbleLight = Color(0xFFFFFFFF);
  static const whatsappReceivedBubbleDark = Color(0xFF1F2C34);
  static const whatsappWallpaperLight = Color(0xFFE5DDD5);
  static const whatsappWallpaperDark = Color(0xFF0D1418);

  // Shared
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
}
