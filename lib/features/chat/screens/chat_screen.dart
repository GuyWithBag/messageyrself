// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/screens/chat_screen.dart
// PURPOSE: Main chat screen with message list, input bar, voice, wallpaper
// PROVIDERS: ChatProvider, VoiceProvider, SettingsProvider
// HOOKS: useTextEditingController, useScrollController, useEffect, useFocusNode, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../features/shell/widgets/quick_theme_panel.dart';
import '../providers/chat_provider.dart';
import '../providers/voice_provider.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_wallpaper.dart';
import '../widgets/message_bubble.dart';
import '../widgets/timestamp_divider.dart';
import '../widgets/voice_waveform.dart';

class ChatScreen extends HookWidget {
  final String sessionId;

  const ChatScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final scrollController = useScrollController();
    final focusNode = useFocusNode();
    final hasText = useState(false);

    final chatProvider = context.watch<ChatProvider>();
    final voiceProvider = context.watch<VoiceProvider>();

    useEffect(() {
      textController.addListener(() {
        hasText.value = textController.text.trim().isNotEmpty;
      });
      return null;
    }, [textController]);

    useEffect(() {
      chatProvider.loadSession(sessionId);
      return null;
    }, [sessionId]);

    useEffect(() {
      if (chatProvider.messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
      return null;
    }, [chatProvider.messages.length]);

    void send() {
      final text = textController.text;
      if (text.trim().isEmpty) return;
      chatProvider.sendMessage(text);
      textController.clear();
      focusNode.requestFocus();
    }

    Future<void> onMicTap() async {
      if (voiceProvider.isRecording) return;
      await voiceProvider.startRecording();
    }

    // Auto-send voice message when recording stops with a path
    useEffect(() {
      final path = voiceProvider.recordingPath;
      if (path != null) {
        chatProvider.sendVoiceMessage(path, voiceProvider.elapsed);
      }
      return null;
    }, [voiceProvider.recordingPath]);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () => showQuickThemePanel(context),
          child: const Text('MessageYrself'),
        ),
        actions: [
          Tooltip(
            message: 'Quick theme',
            child: IconButton(
              icon: const Icon(Icons.palette_outlined),
              onPressed: () => showQuickThemePanel(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatWallpaper(
              child: _MessageList(
                chatProvider: chatProvider,
                scrollController: scrollController,
              ),
            ),
          ),
          if (voiceProvider.isRecording)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: VoiceWaveform(),
            )
          else
            ChatInputBar(
              controller: textController,
              focusNode: focusNode,
              hasText: hasText.value,
              onSend: send,
              onMicTap: onMicTap,
            ),
          SizedBox(
            height: MediaQuery.viewInsetsOf(context).bottom,
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final ChatProvider chatProvider;
  final ScrollController scrollController;

  const _MessageList({
    required this.chatProvider,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (chatProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatProvider.error != null) {
      return _ErrorView(
        error: chatProvider.error!,
        onRetry: () => chatProvider.loadSession(
          chatProvider.activeSessionId ?? 'default',
        ),
      );
    }

    final messages = chatProvider.messages;
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
            !_isSameDay(
              messages[index - 1].createdAt,
              message.createdAt,
            );

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
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Send yourself a message',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
