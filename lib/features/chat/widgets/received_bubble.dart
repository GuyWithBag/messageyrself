// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/received_bubble.dart
// PURPOSE: Received message bubble — left-aligned with preset styling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/theme_extensions/bubble_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../models/message.dart';

class ReceivedBubble extends StatelessWidget {
  final Message message;

  const ReceivedBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bubble = Theme.of(context).extension<BubbleTheme>()!;
    final maxRadius = bubble.bubbleRadius * 20.0;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(maxRadius),
      topRight: Radius.circular(maxRadius),
      bottomLeft: Radius.circular(maxRadius * 0.3),
      bottomRight: Radius.circular(maxRadius),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width *
              AppSpacing.bubbleMaxWidthFraction,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bubble.receivedBubbleColor,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.bubblePaddingH,
              vertical: AppSpacing.bubblePaddingV,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.content ?? '',
                  style: TextStyle(color: bubble.receivedBubbleTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatMessageTime(message.createdAt),
                  style: TextStyle(
                    color: bubble.receivedBubbleTextColor.withAlpha(150),
                    fontSize: 11,
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
