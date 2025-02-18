import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/speach_service.dart';
import 'speach_event.dart';
import 'speach_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechService _speechService;

  SpeechBloc(this._speechService) : super(SpeechInitial()) {
    on<StartListening>((event, emit) async {
      emit(SpeechListening());

      _speechService.listen((recognizedWords) {
        add(SpeechRecognized(recognizedWords, event.targetWords));
      });
    });

  on<SpeechRecognized>((event, emit) {
  List<String> targetWords = event.targetWords.expand((line) => line.split(' ')).toList();
  List<String> recognizedWords = event.recognizedWords.split(' ');

  List<bool> wordMatches = List.generate(targetWords.length, (index) {
    if (index < recognizedWords.length) {
      return targetWords[index].toLowerCase().trim() ==
             recognizedWords[index].toLowerCase().trim();
    }
    return false; // Mark missing words as incorrect
  });

  emit(SpeechSuccess(event.recognizedWords, wordMatches));
});

    on<StopListening>((event, emit) {
      _speechService.stopListening();
      emit(SpeechInitial());
    });
  }
}