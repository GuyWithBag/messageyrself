// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/tags/screens/tag_detail_screen.dart
// PURPOSE: Shows all messages tagged with a specific #tag
// PROVIDERS: TagProvider, ChatProvider
// HOOKS: useScrollController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../chat/models/message.dart';
import '../../chat/providers/chat_provider.dart';
import '../../chat/widgets/message_bubble.dart';
import '../../chat/widgets/timestamp_divider.dart';
import '../providers/tag_provider.dart';

class TagDetailScreen extends HookWidget {
  final String tagId;

  const TagDetailScreen({super.key, required this.tagId});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final tagProvider = context.watch<TagProvider>();
    final chatProvider = context.watch<ChatProvider>();

    useEffect(() {
      tagProvider.loadTags();
      return null;
    }, const []);

    final tag = tagProvider.tags.where((t) => t.id == tagId).firstOrNull;

    final taggedMessages = chatProvider.messages
        .where((m) =>
            m.tags.any((t) => tag != null && t == tag.label))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: tag != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(tag.colorArgb),
                    ),
                  ),
                  Text('#${tag.label}'),
                ],
              )
            : const Text('Tag'),
        actions: [
          _MessageCountBadge(count: taggedMessages.length),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: _MessageList(
        messages: taggedMessages,
        scrollController: scrollController,
        chatProvider: chatProvider,
        isLoading: tagProvider.isLoading,
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final ChatProvider chatProvider;
  final bool isLoading;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.chatProvider,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (messages.isEmpty) {
      return const _EmptyView();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final showDivider = index == 0 ||
            !_isSameDay(messages[index - 1].createdAt, message.createdAt);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDivider) TimestampDivider(dateTime: message.createdAt),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: MessageBubble(
                message: message,
                onDelete: () => chatProvider.deleteMessage(message.id),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tag, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No messages with this tag',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

class _MessageCountBadge extends StatelessWidget {
  final int count;

  const _MessageCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
      ),
    );
  }
}
