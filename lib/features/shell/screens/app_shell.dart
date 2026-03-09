// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/shell/screens/app_shell.dart
// PURPOSE: Responsive shell — mobile nav bar or desktop sidebar
// PROVIDERS: SettingsProvider (reads NavThemeExtension)
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/breakpoints.dart';
import '../../../core/theme/theme_extensions/nav_theme_extension.dart';
import '../widgets/desktop_sidebar.dart';
import '../widgets/mobile_nav_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _DesktopShell(child: child);
        }
        return _MobileShell(child: child);
      },
    );
  }
}

class _MobileShell extends StatelessWidget {
  final Widget child;

  const _MobileShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).extension<NavThemeExtension>()!;
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: MobileNavBar(
        selectedIndex: selectedIndex,
        navTheme: navTheme,
        onDestinationSelected: (index) => _onNav(context, index),
      ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  final Widget child;

  const _DesktopShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).extension<NavThemeExtension>()!;
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      body: Row(
        children: [
          DesktopSidebar(
            selectedIndex: selectedIndex,
            navTheme: navTheme,
            onDestinationSelected: (index) => _onNav(context, index),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

int _indexFromLocation(String location) {
  if (location.startsWith('/tags')) return 1;
  if (location.startsWith('/notebooks')) return 2;
  if (location.startsWith('/settings')) return 3;
  return 0;
}

void _onNav(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go('/chat/default');
    case 1:
      context.go('/tags');
    case 2:
      context.go('/notebooks');
    case 3:
      context.go('/settings');
  }
}
