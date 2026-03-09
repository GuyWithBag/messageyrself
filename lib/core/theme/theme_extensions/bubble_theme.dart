// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/theme_extensions/bubble_theme.dart
// PURPOSE: ThemeExtension for chat bubble styling tokens
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

import 'package:flutter/material.dart';

/// Design tokens for sent and received chat bubbles.
///
/// Read via `Theme.of(context).extension<BubbleTheme>()!`
class BubbleTheme extends ThemeExtension<BubbleTheme> {
  final Color sentBubbleColor;
  final Color receivedBubbleColor;
  final Color sentBubbleTextColor;
  final Color receivedBubbleTextColor;
  final double bubbleRadius;
  final bool hasBubbleTail;
  final bool hasGradientBubble;
  final List<Color>? gradientColors;

  const BubbleTheme({
    required this.sentBubbleColor,
    required this.receivedBubbleColor,
    required this.sentBubbleTextColor,
    required this.receivedBubbleTextColor,
    required this.bubbleRadius,
    this.hasBubbleTail = false,
    this.hasGradientBubble = false,
    this.gradientColors,
  });

  @override
  BubbleTheme copyWith({
    Color? sentBubbleColor,
    Color? receivedBubbleColor,
    Color? sentBubbleTextColor,
    Color? receivedBubbleTextColor,
    double? bubbleRadius,
    bool? hasBubbleTail,
    bool? hasGradientBubble,
    List<Color>? gradientColors,
  }) {
    return BubbleTheme(
      sentBubbleColor: sentBubbleColor ?? this.sentBubbleColor,
      receivedBubbleColor: receivedBubbleColor ?? this.receivedBubbleColor,
      sentBubbleTextColor: sentBubbleTextColor ?? this.sentBubbleTextColor,
      receivedBubbleTextColor:
          receivedBubbleTextColor ?? this.receivedBubbleTextColor,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
      hasBubbleTail: hasBubbleTail ?? this.hasBubbleTail,
      hasGradientBubble: hasGradientBubble ?? this.hasGradientBubble,
      gradientColors: gradientColors ?? this.gradientColors,
    );
  }

  @override
  BubbleTheme lerp(covariant BubbleTheme? other, double t) {
    if (other == null) return this;
    return BubbleTheme(
      sentBubbleColor: Color.lerp(sentBubbleColor, other.sentBubbleColor, t)!,
      receivedBubbleColor:
          Color.lerp(receivedBubbleColor, other.receivedBubbleColor, t)!,
      sentBubbleTextColor:
          Color.lerp(sentBubbleTextColor, other.sentBubbleTextColor, t)!,
      receivedBubbleTextColor:
          Color.lerp(receivedBubbleTextColor, other.receivedBubbleTextColor, t)!,
      bubbleRadius: lerpDouble(bubbleRadius, other.bubbleRadius, t)!,
      hasBubbleTail: t < 0.5 ? hasBubbleTail : other.hasBubbleTail,
      hasGradientBubble: t < 0.5 ? hasGradientBubble : other.hasGradientBubble,
      gradientColors: t < 0.5 ? gradientColors : other.gradientColors,
    );
  }
}
