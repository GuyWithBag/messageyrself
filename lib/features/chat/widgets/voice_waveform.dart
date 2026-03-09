// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/chat/widgets/voice_waveform.dart
// PURPOSE: Animated waveform bars for voice recording visualization
// PROVIDERS: VoiceProvider (watches amplitudes)
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_extensions/input_bar_theme.dart';
import '../providers/voice_provider.dart';

class VoiceWaveform extends StatelessWidget {
  const VoiceWaveform({super.key});

  @override
  Widget build(BuildContext context) {
    final voiceProvider = context.watch<VoiceProvider>();
    final inputTheme = Theme.of(context).extension<InputBarTheme>()!;
    final amplitudes = voiceProvider.amplitudes;
    final elapsed = voiceProvider.elapsed;

    return Row(
      children: [
        _CancelButton(onCancel: voiceProvider.cancelRecording),
        const SizedBox(width: 8),
        _ElapsedLabel(elapsed: elapsed),
        const SizedBox(width: 8),
        Expanded(
          child: _WaveformBars(
            amplitudes: amplitudes,
            color: inputTheme.accentColor,
          ),
        ),
        const SizedBox(width: 8),
        _StopButton(
          color: inputTheme.accentColor,
          onStop: voiceProvider.stopRecording,
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onCancel;

  const _CancelButton({required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Cancel recording',
      child: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onCancel,
      ),
    );
  }
}

class _ElapsedLabel extends StatelessWidget {
  final Duration elapsed;

  const _ElapsedLabel({required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Text(
      '$minutes:$seconds',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
    );
  }
}

class _WaveformBars extends StatelessWidget {
  final List<double> amplitudes;
  final Color color;

  const _WaveformBars({required this.amplitudes, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < amplitudes.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                width: 3,
                height: 4 + (amplitudes[i] * 28),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final Color color;
  final Future<String?> Function() onStop;

  const _StopButton({required this.color, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Stop recording',
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onStop,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.stop, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
