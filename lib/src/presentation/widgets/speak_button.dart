import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/bloc/speach_event.dart';
import '../../business_logic/bloc/speach_state.dart';
import '../../business_logic/bloc/speech_bloc.dart';

class SpeakButton extends StatelessWidget {
 final List<String> targetWords; // ✅ Change to List<String>

  SpeakButton({required this.targetWords});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeechBloc, SpeechState>(
      builder: (context, state) {
        bool isListening = state is SpeechListening;
        
        return ElevatedButton(
          onPressed: () {
            if (isListening) {
              context.read<SpeechBloc>().add(StopListening());
            } else {
              context.read<SpeechBloc>().add(StartListening(targetWords));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isListening ? Colors.red : Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(isListening ? "Stop Listening" : "Speak"),
        );
      },
    );
  }
}