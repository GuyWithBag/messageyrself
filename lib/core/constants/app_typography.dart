// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/constants/app_typography.dart
// PURPOSE: Typography constants and font size mappings
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class AppTypography {
  static const defaultFontFamily = 'Rubik';

  static const availableFonts = [
    'Rubik',
    'Inter',
    'Roboto',
    'Nunito',
    'Poppins',
  ];

  static const fontSizeLabels = ['small', 'medium', 'large'];

  static double bodySize(String fontSize) => switch (fontSize) {
        'small' => 14.0,
        'large' => 18.0,
        _ => 16.0,
      };

  static double titleSize(String fontSize) => switch (fontSize) {
        'small' => 18.0,
        'large' => 24.0,
        _ => 20.0,
      };

  static double captionSize(String fontSize) => switch (fontSize) {
        'small' => 10.0,
        'large' => 14.0,
        _ => 12.0,
      };
}
