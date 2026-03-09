// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/router/app_router.dart
// PURPOSE: go_router configuration with ShellRoute for persistent nav
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:go_router/go_router.dart';

import '../../features/chat/screens/chat_screen.dart';
import '../../features/notebooks/screens/notebooks_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/theme_settings_screen.dart';
import '../../features/shell/screens/app_shell.dart';
import '../../features/tags/screens/tag_detail_screen.dart';
import '../../features/tags/screens/tags_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/chat/default',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/chat/:sessionId',
          name: 'chat',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId'] ?? 'default';
            return ChatScreen(sessionId: sessionId);
          },
        ),
        GoRoute(
          path: '/tags',
          name: 'tags',
          builder: (context, state) => const TagsListScreen(),
          routes: [
            GoRoute(
              path: ':tagId',
              name: 'tagDetail',
              builder: (context, state) {
                final tagId = state.pathParameters['tagId'] ?? '';
                return TagDetailScreen(tagId: tagId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/notebooks',
          name: 'notebooks',
          builder: (context, state) => const NotebooksScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'theme',
              name: 'themeSettings',
              builder: (context, state) => const ThemeSettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
