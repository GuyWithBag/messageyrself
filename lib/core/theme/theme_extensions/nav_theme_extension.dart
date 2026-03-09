// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/theme_extensions/nav_theme_extension.dart
// PURPOSE: ThemeExtension for navigation bar/rail styling tokens
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../layout_preset.dart';

/// Design tokens for bottom nav (mobile) and sidebar (desktop).
///
/// Read via `Theme.of(context).extension<NavThemeExtension>()!`
class NavThemeExtension extends ThemeExtension<NavThemeExtension> {
  final NavStyle navStyle;
  final Color activeIndicatorColor;
  final bool showLabels;

  const NavThemeExtension({
    required this.navStyle,
    required this.activeIndicatorColor,
    required this.showLabels,
  });

  @override
  NavThemeExtension copyWith({
    NavStyle? navStyle,
    Color? activeIndicatorColor,
    bool? showLabels,
  }) {
    return NavThemeExtension(
      navStyle: navStyle ?? this.navStyle,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      showLabels: showLabels ?? this.showLabels,
    );
  }

  @override
  NavThemeExtension lerp(covariant NavThemeExtension? other, double t) {
    if (other == null) return this;
    return NavThemeExtension(
      navStyle: t < 0.5 ? navStyle : other.navStyle,
      activeIndicatorColor:
          Color.lerp(activeIndicatorColor, other.activeIndicatorColor, t)!,
      showLabels: t < 0.5 ? showLabels : other.showLabels,
    );
  }
}
