// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/screens/theme_settings_screen.dart
// PURPOSE: Full theme customization screen with 6 sections
// PROVIDERS: SettingsProvider
// HOOKS: useMemoized
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/layout_preset.dart';
import '../../../core/theme/presets/default_preset.dart';
import '../../../core/theme/presets/instagram_preset.dart';
import '../../../core/theme/presets/messenger_preset.dart';
import '../../../core/theme/presets/whatsapp_preset.dart';
import '../providers/settings_provider.dart';
import '../widgets/accent_color_swatch.dart';
import '../widgets/bubble_radius_slider.dart';
import '../widgets/font_picker_sheet.dart';
import '../widgets/preset_card.dart';
import '../widgets/save_preset_sheet.dart';
import '../widgets/user_preset_card.dart';
import '../widgets/wallpaper_picker.dart';

const _kSwatchColors = [
  Color(0xFFFFFFFF),
  Color(0xFF0A7CFF),
  Color(0xFF833AB4),
  Color(0xFFE91E63),
  Color(0xFFF44336),
  Color(0xFFFF9800),
  Color(0xFFFFEB3B),
  Color(0xFF4CAF50),
  Color(0xFF009688),
  Color(0xFF607D8B),
];

class ThemeSettingsScreen extends HookWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final builtInPresets = useMemoized<List<LayoutPreset>>(
      () => [defaultPreset, messengerPreset, instagramPreset, whatsappPreset],
    );

    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme & Appearance')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          _SectionHeader(title: 'Preset'),
          _PresetRow(
            builtInPresets: builtInPresets,
            provider: provider,
            activePresetId: settings.activePresetId,
          ),
          const _Divider(),
          _SectionHeader(title: 'Colors'),
          _ColorSection(provider: provider, settings: settings),
          const _Divider(),
          _SectionHeader(title: 'Typography'),
          _TypographySection(provider: provider, settings: settings),
          const _Divider(),
          _SectionHeader(title: 'Bubbles'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: BubbleRadiusSlider(
              value: settings.bubbleRadius,
              onChanged: provider.setBubbleRadius,
            ),
          ),
          const _Divider(),
          _SectionHeader(title: 'Wallpaper'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: WallpaperPicker(),
          ),
          const _Divider(),
          _SectionHeader(title: 'Appearance'),
          _AppearanceSection(provider: provider, settings: settings),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// ── Section: Presets ─────────────────────────────

class _PresetRow extends StatelessWidget {
  final List<LayoutPreset> builtInPresets;
  final SettingsProvider provider;
  final String activePresetId;

  const _PresetRow({
    required this.builtInPresets,
    required this.provider,
    required this.activePresetId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          for (final preset in builtInPresets)
            PresetCard(
              preset: preset,
              isSelected: activePresetId == preset.id,
              onTap: () => provider.applyBuiltInPreset(preset.id),
            ),
          for (final userPreset in provider.userPresets)
            UserPresetCard(
              preset: userPreset,
              isSelected: activePresetId == userPreset.id,
              onTap: () => provider.applyUserPreset(userPreset.id),
              onDelete: () => provider.deleteUserPreset(userPreset.id),
            ),
          _SavePresetButton(onTap: () => _showSaveSheet(context)),
        ],
      ),
    );
  }

  void _showSaveSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SavePresetSheet(),
    );
  }
}

class _SavePresetButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SavePresetButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Save current as preset',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: AppSpacing.iconSizeLg,
              ),
              const SizedBox(height: 4),
              Text(
                'Save',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section: Colors ──────────────────────────────

class _ColorSection extends StatelessWidget {
  final SettingsProvider provider;
  final dynamic settings;

  const _ColorSection({required this.provider, required this.settings});

  @override
  Widget build(BuildContext context) {
    final primaryArgb = settings.primaryColorArgb as int;
    final accentArgb = settings.accentColorArgb as int;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Primary', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _kSwatchColors.map((c) {
                return AccentColorSwatch(
                  color: c,
                  isSelected: primaryArgb == c.toARGB32(),
                  onTap: () => provider.setPrimaryColor(c),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Accent', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _kSwatchColors.map((c) {
                return AccentColorSwatch(
                  color: c,
                  isSelected: accentArgb == c.toARGB32(),
                  onTap: () => provider.setAccentColor(c),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => provider.applyBuiltInPreset(
              settings.activePresetId as String,
            ),
            child: const Text('Reset to preset defaults'),
          ),
        ],
      ),
    );
  }
}

// ── Section: Typography ──────────────────────────

class _TypographySection extends StatelessWidget {
  final SettingsProvider provider;
  final dynamic settings;

  const _TypographySection({required this.provider, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Font family'),
            subtitle: Text(settings.fontFamily as String),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => const FontPickerSheet(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Size', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'small', label: Text('Small')),
              ButtonSegment(value: 'medium', label: Text('Medium')),
              ButtonSegment(value: 'large', label: Text('Large')),
            ],
            selected: {settings.fontSize as String},
            onSelectionChanged: (s) => provider.setFontSize(s.first),
          ),
        ],
      ),
    );
  }
}

// ── Section: Appearance ──────────────────────────

class _AppearanceSection extends StatelessWidget {
  final SettingsProvider provider;
  final dynamic settings;

  const _AppearanceSection({required this.provider, required this.settings});

  @override
  Widget build(BuildContext context) {
    final modeValue = settings.themeMode as String;
    final current = switch (modeValue) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(Icons.light_mode),
            label: Text('Light'),
          ),
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(Icons.brightness_auto),
            label: Text('System'),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(Icons.dark_mode),
            label: Text('Dark'),
          ),
        ],
        selected: {current},
        onSelectionChanged: (s) => provider.setThemeMode(s.first),
      ),
    );
  }
}

// ── Shared layout helpers ────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Divider(height: 1),
    );
  }
}
