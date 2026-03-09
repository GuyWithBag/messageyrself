// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/accent_color_swatch.dart
// PURPOSE: Single tappable color swatch circle for color pickers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class AccentColorSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const AccentColorSwatch({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 2.5,
                  )
                : Border.all(color: Colors.transparent, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(100),
                blurRadius: isSelected ? 8 : 0,
                spreadRadius: isSelected ? 1 : 0,
              ),
            ],
          ),
          child: isSelected
              ? Icon(
                  Icons.check,
                  size: 18,
                  color: color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
