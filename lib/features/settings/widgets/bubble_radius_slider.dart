// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/bubble_radius_slider.dart
// PURPOSE: Slider with live bubble preview for adjusting bubble corner radius
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/theme_extensions/bubble_theme.dart';

class BubbleRadiusSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const BubbleRadiusSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BubblePreview(radius: value),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Icon(Icons.crop_square, size: 20),
            Expanded(
              child: Slider(
                value: value,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                onChanged: onChanged,
              ),
            ),
            const Icon(Icons.circle_outlined, size: 20),
          ],
        ),
      ],
    );
  }
}

class _BubblePreview extends StatelessWidget {
  final double radius;

  const _BubblePreview({required this.radius});

  @override
  Widget build(BuildContext context) {
    final bubbleTheme = Theme.of(context).extension<BubbleTheme>()!;
    final cornerRadius = radius * 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bubbleTheme.sentBubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cornerRadius),
              topRight: Radius.circular(cornerRadius),
              bottomLeft: Radius.circular(cornerRadius),
              bottomRight: Radius.circular(cornerRadius * 0.3 + 1),
            ),
          ),
          child: Text(
            'Hello!',
            style: TextStyle(color: bubbleTheme.sentBubbleTextColor),
          ),
        ),
      ],
    );
  }
}
