// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/voice_service.dart
// PURPOSE: Mic recording lifecycle and amplitude polling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../core/errors/app_exception.dart';

/// Manages mic recording, amplitude polling, and temp file I/O.
///
/// Uses the `record` package for cross-platform recording.
class VoiceService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  /// Starts recording to a temp file.
  ///
  /// Throws [VoicePermissionException] if mic permission is denied.
  /// Throws [VoiceRecordingException] on recording failure.
  Future<void> startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        throw const VoicePermissionException(
          message: 'Microphone permission denied',
        );
      }

      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentPath = '${dir.path}/voice_$timestamp.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _currentPath!,
      );
    } on VoicePermissionException {
      rethrow;
    } catch (e) {
      throw VoiceRecordingException(
        message: 'Failed to start recording',
        cause: e,
      );
    }
  }

  /// Stops recording and returns the file path, or null if none active.
  Future<String?> stopRecording() async {
    try {
      final path = await _recorder.stop();
      _currentPath = null;
      return path;
    } catch (e) {
      throw VoiceRecordingException(
        message: 'Failed to stop recording',
        cause: e,
      );
    }
  }

  /// Cancels the current recording and deletes the temp file.
  Future<void> cancelRecording() async {
    try {
      await _recorder.stop();
      if (_currentPath != null) {
        final file = File(_currentPath!);
        if (await file.exists()) {
          await file.delete();
        }
        _currentPath = null;
      }
    } catch (_) {
      _currentPath = null;
    }
  }

  /// Returns normalized amplitude (0.0–1.0) for waveform rendering.
  Future<double> getAmplitude() async {
    try {
      final amplitude = await _recorder.getAmplitude();
      // amplitude.current is in dBFS, typically -160 to 0
      final db = amplitude.current;
      if (db <= -60) return 0.0;
      if (db >= 0) return 1.0;
      return (db + 60) / 60;
    } catch (_) {
      return 0.0;
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
