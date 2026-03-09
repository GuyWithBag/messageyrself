// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/message_bubble.dart
// PURPOSE: Delegates to SentBubble or ReceivedBubble based on message.isSent
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../models/message.dart';
import 'received_bubble.dart';
import 'sent_bubble.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = message.isSent
        ? SentBubble(message: message)
        : ReceivedBubble(message: message);

    if (onDelete == null) return bubble;

    return Dismissible(
      key: ValueKey(message.id),
      direction: DismissDirection.endToStart,
      background: const _DismissBackground(),
      onDismissed: (_) => onDelete?.call(),
      child: bubble,
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Theme.of(context).colorScheme.error.withAlpha(30),
      child: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
