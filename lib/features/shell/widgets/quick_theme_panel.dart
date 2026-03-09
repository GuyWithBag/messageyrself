// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/shell/widgets/quick_theme_panel.dart
// PURPOSE: Quick preset switcher — bottom sheet on mobile, popover on desktop
// PROVIDERS: SettingsProvider
// HOOKS: useMemoized
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/theme/layout_preset.dart';
import '../../../core/theme/presets/default_preset.dart';
import '../../../core/theme/presets/instagram_preset.dart';
import '../../../core/theme/presets/messenger_preset.dart';
import '../../../core/theme/presets/whatsapp_preset.dart';
import '../../settings/providers/settings_provider.dart';
import '../../settings/widgets/accent_color_swatch.dart';
import '../../settings/widgets/preset_card.dart';
import '../../settings/widgets/user_preset_card.dart';

/// Shows the QuickThemePanel for the given [context].
///
/// On mobile: slides up as a ModalBottomSheet.
/// On desktop: not yet a true popover — uses BottomSheet for simplicity in v1.
void showQuickThemePanel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const QuickThemePanel(),
  );
}

const _kAccentColors = [
  Color(0xFF0A7CFF),
  Color(0xFF0084FF),
  Color(0xFF833AB4),
  Color(0xFF25D366),
  Color(0xFFE91E63),
  Color(0xFFFF9800),
  Color(0xFF4CAF50),
  Color(0xFF009688),
];

class QuickThemePanel extends HookWidget {
  const QuickThemePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final builtInPresets = useMemoized<List<LayoutPreset>>(
      () => [defaultPreset, messengerPreset, instagramPreset, whatsappPreset],
    );

    final provider = context.watch<SettingsProvider>();
    final activeId = provider.settings.activePresetId;
    final accentArgb = provider.settings.accentColorArgb;

    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = Breakpoints.isDesktop(constraints.maxWidth);
      final panelHeight = isDesktop ? 220.0 : 280.0;

      return SizedBox(
        height: panelHeight,
        child: Column(
          children: [
            _DragHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick theme',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 118,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  for (final preset in builtInPresets)
                    PresetCard(
                      preset: preset,
                      isSelected: activeId == preset.id,
                      onTap: () => provider.applyBuiltInPreset(preset.id),
                    ),
                  for (final userPreset in provider.userPresets)
                    UserPresetCard(
                      preset: userPreset,
                      isSelected: activeId == userPreset.id,
                      onTap: () => provider.applyUserPreset(userPreset.id),
                      onDelete: () =>
                          provider.deleteUserPreset(userPreset.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: _kAccentColors.map((c) {
                  return AccentColorSwatch(
                    color: c,
                    isSelected: accentArgb == c.toARGB32(),
                    onTap: () => provider.setAccentColor(c),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
