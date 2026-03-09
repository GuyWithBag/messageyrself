// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/chat_wallpaper.dart
// PURPOSE: Renders chat background based on wallpaper settings
// PROVIDERS: SettingsProvider (reads wallpaper tokens)
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/providers/settings_provider.dart';

class ChatWallpaper extends StatelessWidget {
  final Widget child;

  const ChatWallpaper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;
    final type = settings.wallpaperType;
    final value = settings.wallpaperValue;

    return switch (type) {
      'color' => _ColorWallpaper(value: value, child: child),
      'image' => _ImageWallpaper(path: value, child: child),
      _ => child,
    };
  }
}

class _ColorWallpaper extends StatelessWidget {
  final String? value;
  final Widget child;

  const _ColorWallpaper({required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorValue = int.tryParse(value ?? '');
    if (colorValue == null) return child;

    return ColoredBox(
      color: Color(colorValue),
      child: child,
    );
  }
}

class _ImageWallpaper extends StatelessWidget {
  final String? path;
  final Widget child;

  const _ImageWallpaper({required this.path, required this.child});

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) return child;

    final file = File(path!);
    if (!file.existsSync()) return child;

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
