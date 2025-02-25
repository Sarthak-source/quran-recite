import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/speach_service.dart';
import 'speach_event.dart';
import 'speach_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechService _speechService;
  Timer? _restartTimer;

  SpeechBloc(this._speechService) : super(SpeechInitial()) {
    on<StartListening>((event, emit) async {
      emit(SpeechListening());
      _startContinuousListening(event.targetWords);
    });

    on<SpeechRecognized>((event, emit) {
      // Normalize target words.
      List<String> targetWordsWithoutDiacritics = event.targetWords
          .map((line) => removeDiacritics(line))
          .expand((line) => line.split(' '))
          .map((word) => word.toLowerCase().trim())
          .toList();

      // Normalize recognized words.
      List<String> recognizedWordsWithoutDiacritics =
          removeDiacritics(event.recognizedWords)
              .toLowerCase()
              .split(' ')
              .map((word) => word.trim())
              .toList();

      Set<String> targetWordsSet = targetWordsWithoutDiacritics.toSet();
      Set<String> recognizedWordsSet = recognizedWordsWithoutDiacritics.toSet();

      // Calculate initial word matches.
      List<bool> wordMatches = targetWordsWithoutDiacritics.map((targetWord) {
        return recognizedWordsSet.contains(targetWord) ||
            recognizedWordsSet.any((recognizedWord) =>
                isFuzzyMatch(targetWord, recognizedWord, 2) ||
                recognizedWord.contains(targetWord) ||
                targetWord.contains(recognizedWord));
      }).toList();

      // Post-process wordMatches: Only keep contiguous blocks (2 or more trues).
      List<bool> filteredMatches = List.from(wordMatches);
      int n = wordMatches.length;
      int i = 0;
      while (i < n) {
        if (!wordMatches[i]) {
          i++;
          continue;
        }

        // Start of a contiguous block of true values.
        int start = i;
        while (i < n && wordMatches[i]) {
          i++;
        }

        int blockLength = i - start;
        // If the block is smaller than 3, set all values in that block to false.
        if (blockLength < 3) {
          for (int j = start; j < i; j++) {
            filteredMatches[j] = false;
          }
        }
      }

      log("✅ Target Words: $targetWordsSet");
      log("🎙️ Recognized Words: $recognizedWordsSet");
      log("🔍 Original Word Matches: $wordMatches");
      log("🔍 Filtered Word Matches: $filteredMatches");

      emit(SpeechSuccess(event.recognizedWords, filteredMatches));
    });

    on<StopListening>((event, emit) {
      _stopContinuousListening();
      emit(SpeechInitial());
    });
  }

  void _startContinuousListening(List<String> targetWords) {
    _stopContinuousListening(); // Stop existing timer

    //log(targetWords.toString());

    // _restartTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
    //   await _speechService.stopListening(); // Ensure it's stopped
    //   await Future.delayed(
    //       const Duration(microseconds: 500)); // Small buffer time
    _speechService.listen((recognizedWords) {
      add(SpeechRecognized(recognizedWords, targetWords));
    });
    //});
  }

  void _stopContinuousListening() {
    _restartTimer?.cancel();
    _speechService.stopListening();
  }

  String removeDiacritics(String text) {
    final RegExp diacriticsPattern = RegExp(
        r'[\u064B-\u065F\u0617-\u061A\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED\u0670\u0640\u0671]');
    return text.replaceAll(diacriticsPattern, '');
  }

  bool isFuzzyMatch(String word1, String word2, int threshold) {
    int distance = levenshteinDistance(word1, word2);
    return distance <= threshold;
  }

  int levenshteinDistance(String s1, String s2) {
    if (s1.length < s2.length) {
      final temp = s1;
      s1 = s2;
      s2 = temp;
    }

    List<int> prev = List.generate(s2.length + 1, (i) => i);
    List<int> curr = List.filled(s2.length + 1, 0);

    for (int i = 1; i <= s1.length; i++) {
      curr[0] = i;
      for (int j = 1; j <= s2.length; j++) {
        int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
        curr[j] = [curr[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost]
            .reduce((a, b) => a < b ? a : b);
      }
      prev = List.from(curr);
    }

    return curr[s2.length];
  }
}
