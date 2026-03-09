// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/preset_thumbnail_painter.dart
// PURPOSE: CustomPainter that renders a mini chat preview for preset cards
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import 'layout_preset.dart';

/// Renders a miniature chat bubble preview for a [LayoutPreset].
///
/// Used by [PresetCard] to generate thumbnails without a live widget tree.
class PresetThumbnailPainter extends CustomPainter {
  final LayoutPreset preset;

  const PresetThumbnailPainter(this.preset);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgColor = preset.wallpaperType == 'color' &&
            preset.wallpaperValue != null
        ? Color(int.tryParse(preset.wallpaperValue!) ?? 0xFFFFFFFF)
        : const Color(0xFF1C1C1E);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bgColor,
    );

    final radius = preset.bubbleRadius * 12.0;

    // Sent bubble (right)
    _drawBubble(
      canvas,
      rect: Rect.fromLTWH(size.width * 0.35, size.height * 0.15,
          size.width * 0.55, size.height * 0.2),
      color: Color(preset.sentBubbleColorArgb),
      radius: radius,
      preset: preset,
    );

    // Received bubble (left)
    _drawBubble(
      canvas,
      rect: Rect.fromLTWH(size.width * 0.1, size.height * 0.45,
          size.width * 0.5, size.height * 0.2),
      color: Color(preset.receivedBubbleColorArgb),
      radius: radius,
      preset: preset,
    );

    // Second sent bubble (right, smaller)
    _drawBubble(
      canvas,
      rect: Rect.fromLTWH(size.width * 0.45, size.height * 0.72,
          size.width * 0.45, size.height * 0.16),
      color: Color(preset.sentBubbleColorArgb),
      radius: radius,
      preset: preset,
    );
  }

  void _drawBubble(
    Canvas canvas, {
    required Rect rect,
    required Color color,
    required double radius,
    required LayoutPreset preset,
  }) {
    if (preset.hasGradientBubble &&
        preset.gradientColors != null &&
        preset.gradientColors!.length >= 2) {
      final gradient = LinearGradient(colors: preset.gradientColors!);
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        paint,
      );
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(PresetThumbnailPainter oldDelegate) =>
      oldDelegate.preset != preset;
}
