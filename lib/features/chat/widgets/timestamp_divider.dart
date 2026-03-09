// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/timestamp_divider.dart
// PURPOSE: Date divider between message groups in chat
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';

class TimestampDivider extends StatelessWidget {
  final DateTime dateTime;

  const TimestampDivider({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            DateFormatter.formatDivider(dateTime),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
