// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/chat_input_bar.dart
// PURPOSE: Chat message input bar — preset-styled, with send/mic toggle
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/layout_preset.dart';
import '../../../core/theme/theme_extensions/input_bar_theme.dart'
    as app_input;

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasText;
  final VoidCallback onSend;
  final VoidCallback? onMicTap;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasText,
    required this.onSend,
    this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    final inputTheme =
        Theme.of(context).extension<app_input.InputBarTheme>()!;
    final borderRadius = inputTheme.style == InputBarStyle.pill
        ? BorderRadius.circular(inputTheme.height / 2)
        : BorderRadius.circular(12);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: inputTheme.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: borderRadius,
              ),
              child: _InputField(
                controller: controller,
                focusNode: focusNode,
                onSend: onSend,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _SendButton(
            hasText: hasText,
            accentColor: inputTheme.accentColor,
            onSend: onSend,
            onMicTap: onMicTap,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const _SendIntent(),
      },
      child: Actions(
        actions: {
          _SendIntent: CallbackAction<_SendIntent>(
            onInvoke: (_) {
              onSend();
              return null;
            },
          ),
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: null,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            hintText: 'Type a message...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool hasText;
  final Color accentColor;
  final VoidCallback onSend;
  final VoidCallback? onMicTap;

  const _SendButton({
    required this.hasText,
    required this.accentColor,
    required this.onSend,
    this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: hasText ? 'Send' : 'Voice note',
      child: Material(
        color: accentColor,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: hasText ? onSend : onMicTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              hasText ? Icons.send : Icons.mic,
              color: Colors.white,
              size: AppSpacing.iconSizeMd,
            ),
          ),
        ),
      ),
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}
