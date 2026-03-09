// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/user_preset_card.dart
// PURPOSE: Deletable preset card for user-saved presets with thumbnail
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../models/user_preset.dart';

class UserPresetCard extends StatelessWidget {
  final UserPreset preset;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const UserPresetCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Tooltip(
      message: preset.name,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _confirmDelete(context),
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
                _Thumbnail(thumbnailData: preset.thumbnailData),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Text(
                    preset.name,
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

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete preset'),
        content: Text('Delete "${preset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete();
  }
}

class _Thumbnail extends StatelessWidget {
  final String? thumbnailData;

  const _Thumbnail({this.thumbnailData});

  @override
  Widget build(BuildContext context) {
    if (thumbnailData != null) {
      try {
        final bytes = base64Decode(thumbnailData!);
        return SizedBox(
          height: 80,
          width: double.infinity,
          child: Image.memory(bytes, fit: BoxFit.cover),
        );
      } catch (_) {}
    }
    return Container(
      height: 80,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.palette_outlined,
        color: Theme.of(context).colorScheme.outline,
        size: AppSpacing.iconSizeLg,
      ),
    );
  }
}
