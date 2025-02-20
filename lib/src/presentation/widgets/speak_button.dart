import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/bloc/speach_event.dart';
import '../../business_logic/bloc/speach_state.dart';
import '../../business_logic/bloc/speech_bloc.dart';

class SpeakButton extends StatelessWidget {
  final List<String> targetWords;

  const SpeakButton({super.key, required this.targetWords});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeechBloc, SpeechState>(
      builder: (context, state) {
        bool isListening = state is SpeechListening;

        return GestureDetector(
          onTap: () {
            if (isListening) {
              context.read<SpeechBloc>().add(StopListening(targetWords));
            } else {
              context.read<SpeechBloc>().add(StartListening(targetWords));
            }
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isListening ? Colors.grey[600] : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: !isListening
                  ? Icon(
                      Icons.mic,
                      color: isListening ? Colors.white : Colors.red,
                      size: 40,
                    )
                  : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SoundWaveformWidget(),
                  )),
        );
      },
    );
  }
}

class SoundWaveformWidget extends StatefulWidget {
  final int count;
  final double minHeight;
  final double maxHeight;
  final int durationInMilliseconds;
  
  const SoundWaveformWidget({
    Key? key,
    this.count = 6,
    this.minHeight = 10,
    this.maxHeight = 30,
    this.durationInMilliseconds = 500,
  }) : super(key: key);

  @override
  State<SoundWaveformWidget> createState() => _SoundWaveformWidgetState();
}

class _SoundWaveformWidgetState extends State<SoundWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationInMilliseconds),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.count;
    final minHeight = widget.minHeight;
    final maxHeight = widget.maxHeight;
    // Calculate amplitude and baseline to map sine output to our desired height range.
    final amplitude = (maxHeight - minHeight) / 2;
    final baseline = (maxHeight + minHeight) / 2;

    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(count, (i) {
              // Each bar gets a phase offset for a wave-like propagation effect.
              final phaseOffset = (i / count) * 2 * pi;
              // Compute a sine value that oscillates between -1 and 1.
              final sineValue = sin((controller.value * 2 * pi) + phaseOffset);
              // Map the sine value to our height range.
              final barHeight = baseline + amplitude * sineValue;
      
              return Container(
                margin: i == count - 1
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(right: 2.5,left: 2.5),
                height: barHeight,
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(9999),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}