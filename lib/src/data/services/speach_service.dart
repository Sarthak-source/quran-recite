import 'dart:developer';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> listen(Function(String) onResult) async {
    log("Initializing speech recognition...");
    bool available = await _speech.initialize(
      onStatus: (status) => log("Speech status: $status"),
      onError: (error) => log("Speech error: $error"),
    );

    if (available) {
      log("Speech recognition available. Listening...");
      _speech.listen(
        onResult: (result) {
          log("Speech result: ${result.recognizedWords}");
          if (result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(minutes: 10),
        pauseFor: const Duration(seconds: 5),
        localeId: "ar-SA",
      );
    } else {
      log("Speech recognition not available.");
    }
  }

  void stopListening() {
    log("Stopping speech recognition...");
    _speech.stop();
  }

  // ✅ Remove Tashkeel (diacritics) from Arabic text
  String removeTashkeel(String text) {
    log("Removing Tashkeel from text: $text");
    final cleanedText = text
        .replaceAll(RegExp(r'[\u064B-\u065F]'), '') // Remove Tashkeel
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .trim();
    log("Cleaned text: $cleanedText");
    return cleanedText;
  }
}
