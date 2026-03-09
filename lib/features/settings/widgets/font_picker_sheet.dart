// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/settings/widgets/font_picker_sheet.dart
// PURPOSE: Bottom sheet for selecting font family with live preview
// PROVIDERS: SettingsProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../providers/settings_provider.dart';

const _kFonts = ['Rubik', 'Inter', 'Roboto', 'Nunito', 'Poppins'];

class FontPickerSheet extends StatelessWidget {
  const FontPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.watch<SettingsProvider>().settings.fontFamily;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Text(
                'Font family',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _kFonts.length,
          itemBuilder: (context, index) {
            final font = _kFonts[index];
            final isSelected = font == current;
            return ListTile(
              title: Text(
                'The quick brown fox — $font',
                style: GoogleFonts.getFont(font),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              selected: isSelected,
              onTap: () {
                context.read<SettingsProvider>().setFontFamily(font);
                Navigator.pop(context);
              },
            );
          },
        ),
        SizedBox(
          height: MediaQuery.viewPaddingOf(context).bottom + AppSpacing.md,
        ),
      ],
    );
  }
}
