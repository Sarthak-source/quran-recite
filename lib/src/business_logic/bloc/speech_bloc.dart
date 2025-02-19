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
      List<String> targetWordsWithoutDiacritics = event.targetWords
          .map((line) => removeDiacritics(line))
          .expand((line) => line.split(' '))
          .toList();

      List<String> recognizedWordsWithoutDiacritics =
          removeDiacritics(event.recognizedWords).split(' ');

      List<bool> wordMatches = List.generate(
        targetWordsWithoutDiacritics.length,
        (index) {
          if (index < recognizedWordsWithoutDiacritics.length) {
            String targetWord =
                targetWordsWithoutDiacritics[index].toLowerCase().trim();
            String recognizedWord =
                recognizedWordsWithoutDiacritics[index].toLowerCase().trim();

            bool exactMatch = targetWord == recognizedWord;
            bool fuzzyMatch = isFuzzyMatch(targetWord, recognizedWord, 3);
            bool partialMatch = recognizedWord.contains(targetWord) ||
                targetWord.contains(recognizedWord);

            bool finalMatch = exactMatch || fuzzyMatch || partialMatch;

            log("🔎 Comparing: '$targetWord' with '$recognizedWord' → "
                "${exactMatch ? "✅ Exact Match" : fuzzyMatch ? "🟡 Fuzzy Match" : partialMatch ? "🟠 Partial Match" : "❌ Mismatch"}");

            return finalMatch;
          }
          return false;
        },
      );

      log("✅ Word Matches: $wordMatches");

      emit(SpeechSuccess(event.recognizedWords, wordMatches));
    });

    on<StopListening>((event, emit) {
      _stopContinuousListening();
      emit(SpeechInitial());
    });
  }

  void _startContinuousListening(List<String> targetWords) {
    _stopContinuousListening(); // Stop existing timer

    _restartTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _speechService.stopListening(); // Ensure it's stopped
      await Future.delayed(Duration(milliseconds: 500)); // Small buffer time
      _speechService.listen((recognizedWords) {
        add(SpeechRecognized(recognizedWords, targetWords));
      });
    });
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
    int len1 = s1.length, len2 = s2.length;
    List<List<int>> dp =
        List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));

    for (int i = 0; i <= len1; i++) {
      dp[i][0] = i;
    }
    for (int j = 0; j <= len2; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[len1][len2];
  }
}
