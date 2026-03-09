// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/theme_extensions/input_bar_theme.dart
// PURPOSE: ThemeExtension for chat input bar styling tokens
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

import 'package:flutter/material.dart';

import '../layout_preset.dart';

/// Design tokens for the chat input bar.
///
/// Read via `Theme.of(context).extension<InputBarTheme>()!`
class InputBarTheme extends ThemeExtension<InputBarTheme> {
  final InputBarStyle style;
  final double height;
  final Color accentColor;

  const InputBarTheme({
    required this.style,
    required this.height,
    required this.accentColor,
  });

  @override
  InputBarTheme copyWith({
    InputBarStyle? style,
    double? height,
    Color? accentColor,
  }) {
    return InputBarTheme(
      style: style ?? this.style,
      height: height ?? this.height,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  InputBarTheme lerp(covariant InputBarTheme? other, double t) {
    if (other == null) return this;
    return InputBarTheme(
      style: t < 0.5 ? style : other.style,
      height: lerpDouble(height, other.height, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
    );
  }
}
