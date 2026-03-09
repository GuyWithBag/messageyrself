// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/notebooks/screens/notebooks_screen.dart
// PURPOSE: Lists notebooks; expands to show sessions; tap session to open chat
// PROVIDERS: NotebookProvider
// HOOKS: useEffect, useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../chat/models/session.dart';
import '../providers/notebook_provider.dart';
import '../widgets/notebook_list_tile.dart';

class NotebooksScreen extends HookWidget {
  const NotebooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotebookProvider>();

    useEffect(() {
      provider.loadNotebooks();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Notebooks')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateNotebookSheet(context, provider),
        tooltip: 'New notebook',
        child: const Icon(Icons.add),
      ),
      body: _Body(provider: provider),
    );
  }

  void _showCreateNotebookSheet(
      BuildContext context, NotebookProvider provider) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _CreateNotebookSheet(provider: provider),
    );
  }
}

class _Body extends StatelessWidget {
  final NotebookProvider provider;

  const _Body({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return _ErrorView(error: provider.error!, onRetry: provider.loadNotebooks);
    }

    if (provider.notebooks.isEmpty) {
      return const _EmptyView();
    }

    return ListView.separated(
      itemCount: provider.notebooks.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notebook = provider.notebooks[index];
        final sessions = provider.sessionsFor(notebook.id);
        return _NotebookExpansionTile(
          notebook: NotebookListTile(
            notebook: notebook,
            onTap: () {},
            onDelete: notebook.id == 'default'
                ? null
                : () => provider.deleteNotebook(notebook.id),
          ),
          sessions: sessions,
          notebookId: notebook.id,
          provider: provider,
        );
      },
    );
  }
}

class _NotebookExpansionTile extends StatelessWidget {
  final NotebookListTile notebook;
  final List<Session> sessions;
  final String notebookId;
  final NotebookProvider provider;

  const _NotebookExpansionTile({
    required this.notebook,
    required this.sessions,
    required this.notebookId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(notebook.notebook.colorArgb),
            ),
          ),
          Expanded(child: Text(notebook.notebook.title)),
        ],
      ),
      subtitle: Text(
        '${sessions.length} session${sessions.length == 1 ? '' : 's'}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      trailing: notebookId == 'default'
          ? null
          : IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Theme.of(context).colorScheme.error,
              tooltip: 'Delete notebook',
              onPressed: () => provider.deleteNotebook(notebookId),
            ),
      children: [
        ...sessions.map(
          (session) => _SessionTile(
            session: session,
            onTap: () => context.go('/chat/${session.id}'),
            onDelete: session.id == 'default'
                ? null
                : () => provider.deleteSession(session.id),
          ),
        ),
        _AddSessionTile(
          onAdd: () => _showCreateSessionSheet(context, notebookId, provider),
        ),
      ],
    );
  }

  void _showCreateSessionSheet(
      BuildContext context, String notebookId, NotebookProvider provider) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) =>
          _CreateSessionSheet(notebookId: notebookId, provider: provider),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final Session session;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _SessionTile({
    required this.session,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: AppSpacing.xxl + AppSpacing.sm,
        right: AppSpacing.sm,
      ),
      leading: const Icon(Icons.chat_bubble_outline, size: 18),
      title: Text(session.title),
      subtitle: Text(
        '${session.messageCount} message${session.messageCount == 1 ? '' : 's'}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Theme.of(context).colorScheme.error,
              onPressed: onDelete,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _AddSessionTile extends StatelessWidget {
  final VoidCallback onAdd;

  const _AddSessionTile({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: AppSpacing.xxl + AppSpacing.sm,
        right: AppSpacing.sm,
      ),
      leading: const Icon(Icons.add, size: 18),
      title: Text(
        'New session',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      onTap: onAdd,
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.book_outlined,
              size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No notebooks yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap + to create your first notebook',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          Icon(Icons.error_outline,
              size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: AppSpacing.md),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _CreateNotebookSheet extends HookWidget {
  final NotebookProvider provider;

  const _CreateNotebookSheet({required this.provider});

  static const _kColors = [
    0xFF0A7CFF, 0xFF833AB4, 0xFF25D366, 0xFFE91E63,
    0xFFFF9800, 0xFF009688, 0xFF607D8B, 0xFFF44336,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final selectedColor = useState(_kColors[0]);
    final isLoading = useState(false);

    useEffect(() {
      Future.microtask(() => focusNode.requestFocus());
      return null;
    }, const []);

    Future<void> submit() async {
      final title = controller.text.trim();
      if (title.isEmpty) return;
      isLoading.value = true;
      await provider.createNotebook(
          title: title, colorArgb: selectedColor.value);
      isLoading.value = false;
      if (context.mounted) Navigator.of(context).pop();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Notebook',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => submit(),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: _kColors.map((c) {
              final isSelected = selectedColor.value == c;
              return GestureDetector(
                onTap: () => selectedColor.value = c,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(c),
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 2.5,
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading.value ? null : submit,
              child: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateSessionSheet extends HookWidget {
  final String notebookId;
  final NotebookProvider provider;

  const _CreateSessionSheet({
    required this.notebookId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final isLoading = useState(false);

    useEffect(() {
      Future.microtask(() => focusNode.requestFocus());
      return null;
    }, const []);

    Future<void> submit() async {
      final title = controller.text.trim();
      if (title.isEmpty) return;
      isLoading.value = true;
      final session = await provider.createSession(
        notebookId: notebookId,
        title: title,
      );
      isLoading.value = false;
      if (context.mounted) {
        Navigator.of(context).pop();
        context.go('/chat/${session.id}');
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Session', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
              labelText: 'Session title',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => submit(),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading.value ? null : submit,
              child: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create'),
            ),
          ),
        ],
      ),
    );
  }
}
