// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/tags/widgets/tag_list_tile.dart
// PURPOSE: ListTile for a tag showing colored dot, label, and message count
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../models/tag.dart';

class TagListTile extends StatelessWidget {
  final Tag tag;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const TagListTile({
    super.key,
    required this.tag,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _ColorDot(color: Color(tag.colorArgb)),
      title: Text('#${tag.label}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CountBadge(count: tag.messageCount),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            _DeleteButton(onDelete: onDelete!),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const _DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Delete tag',
      child: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: onDelete,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
