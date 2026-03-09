// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/screens/settings_screen.dart
// PURPOSE: Main settings screen — groups all app settings into sections
// PROVIDERS: SettingsProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Appearance ────────────────────────────
          _SectionHeader(label: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme & Appearance'),
            subtitle: Text(settings.activePreset.displayName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/theme'),
          ),
          _ThemeModeTile(settings: settings),
          const Divider(height: 1),

          // ── Chat ─────────────────────────────────
          _SectionHeader(label: 'Chat'),
          _FontSizeTile(settings: settings),
          const Divider(height: 1),

          // ── Data ─────────────────────────────────
          _SectionHeader(label: 'Data'),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Clear all data'),
            subtitle: const Text('Permanently delete all messages and notebooks'),
            onTap: () => _confirmClearData(context),
          ),
          const Divider(height: 1),

          // ── About ────────────────────────────────
          _SectionHeader(label: 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('MessageYrself'),
            subtitle: Text('v1.0.0'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _confirmClearData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This will permanently delete all messages, notebooks, tags, and sessions. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final hive = context.read<SettingsProvider>();
      // Settings provider doesn't expose clearAll — show snackbar info
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clear data is not yet implemented.'),
        ),
      );
      hive.clearError();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.1,
            ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  final SettingsProvider settings;

  const _ThemeModeTile({required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brightness_auto_outlined),
      title: const Text('Appearance'),
      subtitle: Text(_themeModeLabel(settings.themeMode)),
      trailing: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(Icons.light_mode_outlined, size: 18),
            tooltip: 'Light',
          ),
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(Icons.brightness_auto_outlined, size: 18),
            tooltip: 'System',
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(Icons.dark_mode_outlined, size: 18),
            tooltip: 'Dark',
          ),
        ],
        selected: {settings.themeMode},
        onSelectionChanged: (v) => settings.setThemeMode(v.first),
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        _ => 'System',
      };
}

class _FontSizeTile extends StatelessWidget {
  final SettingsProvider settings;

  const _FontSizeTile({required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.format_size_outlined),
      title: const Text('Text size'),
      subtitle: Text(_fontSizeLabel(settings.settings.fontSize)),
      trailing: SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: 'small',
            icon: Icon(Icons.text_fields, size: 14),
            tooltip: 'Small',
          ),
          ButtonSegment(
            value: 'medium',
            icon: Icon(Icons.text_fields, size: 18),
            tooltip: 'Medium',
          ),
          ButtonSegment(
            value: 'large',
            icon: Icon(Icons.text_fields, size: 22),
            tooltip: 'Large',
          ),
        ],
        selected: {settings.settings.fontSize},
        onSelectionChanged: (v) => settings.setFontSize(v.first),
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  String _fontSizeLabel(String size) => switch (size) {
        'small' => 'Small',
        'large' => 'Large',
        _ => 'Medium',
      };
}
