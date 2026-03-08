// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/hive_service.dart
// PURPOSE: Initializes Hive CE, registers adapters, exposes typed boxes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../core/errors/app_exception.dart';
import '../features/chat/models/message.dart';
import '../features/chat/models/session.dart';
import '../features/notebooks/models/notebook.dart';
import '../features/settings/models/app_settings.dart';
import '../features/settings/models/user_preset.dart';
import '../features/tags/models/tag.dart';

/// Manages Hive CE initialization, adapter registration, and box access.
///
/// Must call [init] before accessing any box getters.
/// All boxes are opened during init and remain open for the app lifetime.
class HiveService {
  Box<Message>? _messagesBox;
  Box<Session>? _sessionsBox;
  Box<Tag>? _tagsBox;
  Box<Notebook>? _notebooksBox;
  Box<AppSettings>? _settingsBox;
  Box<UserPreset>? _userPresetsBox;

  /// Initializes Hive, registers all adapters, and opens all boxes.
  ///
  /// Throws [HiveInitException] on adapter conflict or box open failure.
  Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init('${dir.path}/messageyrself_hive');

      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(SessionAdapter());
      Hive.registerAdapter(TagAdapter());
      Hive.registerAdapter(NotebookAdapter());
      Hive.registerAdapter(AppSettingsAdapter());
      Hive.registerAdapter(UserPresetAdapter());

      _messagesBox = await Hive.openBox<Message>('messages');
      _sessionsBox = await Hive.openBox<Session>('sessions');
      _tagsBox = await Hive.openBox<Tag>('tags');
      _notebooksBox = await Hive.openBox<Notebook>('notebooks');
      _settingsBox = await Hive.openBox<AppSettings>('settings');
      _userPresetsBox = await Hive.openBox<UserPreset>('user_presets');
    } catch (e) {
      throw HiveInitException(
        message: 'Failed to initialize Hive',
        cause: e,
      );
    }
  }

  Box<Message> get messagesBox => _messagesBox!;
  Box<Session> get sessionsBox => _sessionsBox!;
  Box<Tag> get tagsBox => _tagsBox!;
  Box<Notebook> get notebooksBox => _notebooksBox!;
  Box<AppSettings> get settingsBox => _settingsBox!;
  Box<UserPreset> get userPresetsBox => _userPresetsBox!;
}
