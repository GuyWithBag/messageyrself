// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/main.dart
// PURPOSE: App entry point — initializes Hive and registers providers
// PROVIDERS: SettingsProvider, ChatProvider, TagProvider, NotebookProvider, VoiceProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  runApp(MessageYrselfApp(hiveService: hiveService));
}

class MessageYrselfApp extends StatelessWidget {
  final HiveService hiveService;

  const MessageYrselfApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    // Providers will be added here as they are built.
    // For now, provide HiveService via Provider.value.
    return Provider<HiveService>.value(
      value: hiveService,
      child: MaterialApp(
        title: 'MessageYrself',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A7CFF)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0A7CFF),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: Text('MessageYrself — core initialized'),
          ),
        ),
      ),
    );
  }
}
