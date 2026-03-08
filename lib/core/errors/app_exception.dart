// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/errors/app_exception.dart
// PURPOSE: App exception hierarchy for typed error handling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Object? cause;

  const AppException({
    required this.message,
    this.code,
    this.cause,
  });

  @override
  String toString() => '$runtimeType: $message';
}

class HiveInitException extends AppException {
  const HiveInitException({
    required super.message,
    super.code,
    super.cause,
  });
}

class VoicePermissionException extends AppException {
  const VoicePermissionException({
    required super.message,
    super.code,
    super.cause,
  });
}

class VoiceRecordingException extends AppException {
  const VoiceRecordingException({
    required super.message,
    super.code,
    super.cause,
  });
}

class PresetNotFoundException extends AppException {
  const PresetNotFoundException({
    required super.message,
    super.code,
    super.cause,
  });
}
