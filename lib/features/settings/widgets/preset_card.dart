// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/preset_card.dart
// PURPOSE: Tappable card showing a preset thumbnail + name for built-in presets
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/theme/layout_preset.dart';
import '../../../core/theme/preset_thumbnail_painter.dart';

class PresetCard extends StatelessWidget {
  final LayoutPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const PresetCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Tooltip(
      message: preset.displayName,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? accent : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: accent.withAlpha(60),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: PresetThumbnailPainter(preset),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Text(
                    preset.displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
