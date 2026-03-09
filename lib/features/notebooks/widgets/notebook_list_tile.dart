// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/notebooks/widgets/notebook_list_tile.dart
// PURPOSE: ListTile for a notebook showing colored dot, title, and session count
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../models/notebook.dart';

class NotebookListTile extends StatelessWidget {
  final Notebook notebook;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const NotebookListTile({
    super.key,
    required this.notebook,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _ColorDot(color: Color(notebook.colorArgb)),
      title: Text(notebook.title),
      subtitle: Text(
        '${notebook.sessionCount} session${notebook.sessionCount == 1 ? '' : 's'}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      trailing: onDelete != null
          ? Tooltip(
              message: 'Delete notebook',
              child: IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete,
                color: Theme.of(context).colorScheme.error,
              ),
            )
          : null,
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
