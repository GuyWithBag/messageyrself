// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/providers/voice_provider.dart
// PURPOSE: Manages voice recording state, amplitudes, and elapsed time
// PROVIDERS: VoiceProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../services/voice_service.dart';

/// Manages voice recording state including amplitude polling and elapsed timer.
///
/// Exposes [isRecording], [amplitudes] (rolling list for waveform),
/// [elapsed], and [recordingPath] after stop.
class VoiceProvider extends ChangeNotifier {
  final VoiceService _voiceService;

  bool _isRecording = false;
  List<double> _amplitudes = [];
  String? _recordingPath;
  Duration _elapsed = Duration.zero;
  String? _error;

  Timer? _amplitudeTimer;
  Timer? _elapsedTimer;

  static const int _maxAmplitudes = 40;

  VoiceProvider(this._voiceService);

  bool get isRecording => _isRecording;
  List<double> get amplitudes => List.unmodifiable(_amplitudes);
  String? get recordingPath => _recordingPath;
  Duration get elapsed => _elapsed;
  String? get error => _error;

  /// Starts recording and begins amplitude/elapsed polling.
  Future<void> startRecording() async {
    try {
      await _voiceService.startRecording();
      _isRecording = true;
      _amplitudes = [];
      _elapsed = Duration.zero;
      _recordingPath = null;
      _error = null;

      _amplitudeTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => _pollAmplitude(),
      );

      _elapsedTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          _elapsed += const Duration(seconds: 1);
          notifyListeners();
        },
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isRecording = false;
      notifyListeners();
    }
  }

  /// Stops recording and returns the file path.
  Future<String?> stopRecording() async {
    try {
      _stopTimers();
      final path = await _voiceService.stopRecording();
      _isRecording = false;
      _recordingPath = path;
      _error = null;
      notifyListeners();
      return path;
    } catch (e) {
      _error = e.toString();
      _isRecording = false;
      notifyListeners();
      return null;
    }
  }

  /// Cancels recording and discards the temp file.
  Future<void> cancelRecording() async {
    _stopTimers();
    await _voiceService.cancelRecording();
    _isRecording = false;
    _amplitudes = [];
    _elapsed = Duration.zero;
    _recordingPath = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimers();
    _voiceService.dispose();
    super.dispose();
  }

  // ── Private helpers ─────────────────────────────

  void _stopTimers() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
  }

  Future<void> _pollAmplitude() async {
    final amp = await _voiceService.getAmplitude();
    _amplitudes.add(amp);
    if (_amplitudes.length > _maxAmplitudes) {
      _amplitudes = _amplitudes.sublist(_amplitudes.length - _maxAmplitudes);
    }
    notifyListeners();
  }
}
