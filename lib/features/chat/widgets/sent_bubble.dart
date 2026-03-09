// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/sent_bubble.dart
// PURPOSE: Sent message bubble — supports solid fill and gradient
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/theme_extensions/bubble_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../models/message.dart';

class SentBubble extends StatelessWidget {
  final Message message;

  const SentBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bubble = Theme.of(context).extension<BubbleTheme>()!;
    final maxRadius = bubble.bubbleRadius * 20.0;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(maxRadius),
      topRight: Radius.circular(maxRadius),
      bottomLeft: Radius.circular(maxRadius),
      bottomRight: Radius.circular(maxRadius * 0.3),
    );

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width *
              AppSpacing.bubbleMaxWidthFraction,
        ),
        child: DecoratedBox(
          decoration: bubble.hasGradientBubble && bubble.gradientColors != null
              ? BoxDecoration(
                  gradient: LinearGradient(colors: bubble.gradientColors!),
                  borderRadius: borderRadius,
                )
              : BoxDecoration(
                  color: bubble.sentBubbleColor,
                  borderRadius: borderRadius,
                ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.bubblePaddingH,
              vertical: AppSpacing.bubblePaddingV,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.content ?? '',
                  style: TextStyle(color: bubble.sentBubbleTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatMessageTime(message.createdAt),
                  style: TextStyle(
                    color: bubble.sentBubbleTextColor.withAlpha(150),
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
