// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/tags/screens/tags_list_screen.dart
// PURPOSE: Lists all tags with message counts; tap to open TagDetailScreen
// PROVIDERS: TagProvider
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../providers/tag_provider.dart';
import '../widgets/tag_list_tile.dart';

class TagsListScreen extends HookWidget {
  const TagsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TagProvider>();

    useEffect(() {
      provider.loadTags();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: _Body(provider: provider),
    );
  }
}

class _Body extends StatelessWidget {
  final TagProvider provider;

  const _Body({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return _ErrorView(error: provider.error!, onRetry: provider.loadTags);
    }

    if (provider.tags.isEmpty) {
      return const _EmptyView();
    }

    return ListView.separated(
      itemCount: provider.tags.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tag = provider.tags[index];
        return TagListTile(
          tag: tag,
          onTap: () => context.push('/tags/${tag.id}'),
          onDelete: () => provider.deleteTag(tag.id),
        );
      },
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
          Icon(Icons.tag, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: AppSpacing.lg),
          Text('No tags yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  )),
          const SizedBox(height: AppSpacing.sm),
          Text('Use #hashtags in your messages',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  )),
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
