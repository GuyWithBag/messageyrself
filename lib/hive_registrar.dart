// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/hive_registrar.dart
// PURPOSE: Central Hive adapter registration via @GenerateAdapters
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';

import 'features/chat/models/message.dart';
import 'features/chat/models/session.dart';
import 'features/notebooks/models/notebook.dart';
import 'features/settings/models/app_settings.dart';
import 'features/settings/models/user_preset.dart';
import 'features/tags/models/tag.dart';

part 'hive_registrar.g.dart';

@GenerateAdapters([
  AdapterSpec<Message>(),
  AdapterSpec<Session>(),
  AdapterSpec<Tag>(),
  AdapterSpec<Notebook>(),
  AdapterSpec<AppSettings>(),
  AdapterSpec<UserPreset>(),
])
// ignore: unused_element
void _hiveRegistrar() {}
