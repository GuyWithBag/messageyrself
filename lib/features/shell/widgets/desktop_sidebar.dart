// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/shell/widgets/desktop_sidebar.dart
// PURPOSE: NavigationRail sidebar for desktop — collapsible, tooltipped
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions/nav_theme_extension.dart';

class DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final NavThemeExtension navTheme;
  final ValueChanged<int> onDestinationSelected;

  const DesktopSidebar({
    super.key,
    required this.selectedIndex,
    required this.navTheme,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: true,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: navTheme.activeIndicatorColor.withAlpha(30),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'MessageYrself',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Tooltip(
            message: 'Chat',
            child: Icon(Icons.chat_bubble_outline),
          ),
          selectedIcon: Icon(Icons.chat_bubble),
          label: Text('Chat'),
        ),
        NavigationRailDestination(
          icon: Tooltip(
            message: 'Tags',
            child: Icon(Icons.tag_outlined),
          ),
          selectedIcon: Icon(Icons.tag),
          label: Text('Tags'),
        ),
        NavigationRailDestination(
          icon: Tooltip(
            message: 'Notebooks',
            child: Icon(Icons.book_outlined),
          ),
          selectedIcon: Icon(Icons.book),
          label: Text('Notebooks'),
        ),
        NavigationRailDestination(
          icon: Tooltip(
            message: 'Settings',
            child: Icon(Icons.settings_outlined),
          ),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
