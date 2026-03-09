// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/wallpaper_picker.dart
// PURPOSE: Chip row for selecting wallpaper type (none/color/gradient/image)
// PROVIDERS: SettingsProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../providers/settings_provider.dart';

const _kWallpaperColors = [
  0xFFE5DDD5,
  0xFF1A1A2E,
  0xFF0D1B2A,
  0xFF1B1B2F,
  0xFF2C3E50,
  0xFF1A1A1A,
];

class WallpaperPicker extends StatelessWidget {
  const WallpaperPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final wallType = provider.settings.wallpaperType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TypeChips(current: wallType),
        const SizedBox(height: AppSpacing.md),
        if (wallType == 'color') _ColorSwatches(provider: provider),
        if (wallType == 'image') _ImagePicker(provider: provider),
      ],
    );
  }
}

class _TypeChips extends StatelessWidget {
  final String current;

  const _TypeChips({required this.current});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SettingsProvider>();
    const types = ['none', 'color', 'gradient', 'image'];
    const labels = ['None', 'Color', 'Gradient', 'Image'];

    return Wrap(
      spacing: AppSpacing.sm,
      children: List.generate(types.length, (i) {
        return ChoiceChip(
          label: Text(labels[i]),
          selected: current == types[i],
          onSelected: (_) {
            if (types[i] == 'gradient') {
              provider.setWallpaper('gradient', null);
            } else if (types[i] == 'none') {
              provider.setWallpaper('none', null);
            }
            // color and image are handled by their sub-pickers
            else if (types[i] == 'color') {
              provider.setWallpaper(
                  'color', '0x${_kWallpaperColors.first.toRadixString(16)}');
            }
          },
        );
      }),
    );
  }
}

class _ColorSwatches extends StatelessWidget {
  final SettingsProvider provider;

  const _ColorSwatches({required this.provider});

  @override
  Widget build(BuildContext context) {
    final currentVal = provider.settings.wallpaperValue;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _kWallpaperColors.map((argb) {
        final hex = '0x${argb.toRadixString(16)}';
        final isSelected = currentVal == hex;
        return GestureDetector(
          onTap: () => provider.setWallpaper('color', hex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(argb),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    )
                  : Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final SettingsProvider provider;

  const _ImagePicker({required this.provider});

  @override
  Widget build(BuildContext context) {
    final hasImage = provider.settings.wallpaperValue != null;

    return OutlinedButton.icon(
      icon: const Icon(Icons.image_outlined),
      label: Text(hasImage ? 'Change image' : 'Pick image'),
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result != null && result.files.single.path != null) {
          provider.setWallpaper('image', result.files.single.path!);
        }
      },
    );
  }
}
