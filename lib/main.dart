// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/main.dart
// PURPOSE: App entry point — initializes Hive and registers providers
// PROVIDERS: SettingsProvider, ChatProvider, TagProvider, NotebookProvider, VoiceProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'features/chat/providers/chat_provider.dart';
import 'features/chat/providers/voice_provider.dart';
import 'features/notebooks/providers/notebook_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/tags/providers/tag_provider.dart';
import 'services/hive_service.dart';
import 'services/voice_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  final settingsProvider = SettingsProvider(hiveService);
  await settingsProvider.loadSettings();

  runApp(
    MessageYrselfApp(
      hiveService: hiveService,
      settingsProvider: settingsProvider,
    ),
  );
}

class MessageYrselfApp extends StatelessWidget {
  final HiveService hiveService;
  final SettingsProvider settingsProvider;

  const MessageYrselfApp({
    super.key,
    required this.hiveService,
    required this.settingsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HiveService>.value(value: hiveService),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: settingsProvider,
        ),
        ChangeNotifierProvider<TagProvider>(
          create: (context) => TagProvider(hiveService),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            hiveService,
            context.read<TagProvider>(),
          ),
        ),
        ChangeNotifierProvider<NotebookProvider>(
          create: (context) => NotebookProvider(hiveService),
        ),
        ChangeNotifierProvider<VoiceProvider>(
          create: (context) => VoiceProvider(VoiceService()),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            title: 'MessageYrself',
            debugShowCheckedModeBanner: false,
            theme: settings.lightTheme,
            darkTheme: settings.darkTheme,
            themeMode: settings.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
