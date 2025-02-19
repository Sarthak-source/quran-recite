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
      List<String> targetWords = event.targetWords
          .expand((line) => line.split(RegExp(r'\s+')))
          .map(_speechService.removeTashkeel)
          .toList();

      List<String> recognizedWords = event.recognizedWords
          .split(RegExp(r'\s+'))
          .map(_speechService.removeTashkeel)
          .toList();

      print("📢 Target Words: $targetWords");
      print("📝 Recognized Words: $recognizedWords");

      // Compare each recognized word with target words
      List<bool> wordMatches = recognizedWords.map((word) {
        return targetWords.contains(word);
      }).toList();

      emit(SpeechSuccess(event.recognizedWords, wordMatches));
    });

    on<StopListening>((event, emit) {
      _speechService.stopListening();
      emit(SpeechInitial());
    });
  }
}
