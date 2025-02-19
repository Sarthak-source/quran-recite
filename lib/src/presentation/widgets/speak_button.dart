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
            width: 60,
            height: 60,
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
            child: Icon(
              isListening ? Icons.mic_external_off : Icons.mic,
              color: isListening ? Colors.white : Colors.red,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}
