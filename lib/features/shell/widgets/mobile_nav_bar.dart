// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/shell/widgets/mobile_nav_bar.dart
// PURPOSE: Bottom NavigationBar for mobile — preset-driven styling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions/nav_theme_extension.dart';

class MobileNavBar extends StatelessWidget {
  final int selectedIndex;
  final NavThemeExtension navTheme;
  final ValueChanged<int> onDestinationSelected;

  const MobileNavBar({
    super.key,
    required this.selectedIndex,
    required this.navTheme,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: navTheme.activeIndicatorColor.withAlpha(30),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.tag_outlined),
          selectedIcon: Icon(Icons.tag),
          label: 'Tags',
        ),
        NavigationDestination(
          icon: Icon(Icons.book_outlined),
          selectedIcon: Icon(Icons.book),
          label: 'Notebooks',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
