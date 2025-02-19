import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  void listen(Function(String) onResult) async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            onResult(result
                .recognizedWords); // ✅ Extract text from SpeechRecognitionResult
          }
        },
        listenFor: Duration(minutes: 10),
        pauseFor: Duration(seconds: 5),
        localeId: "ar-SA",
      );
    }
  }

  void stopListening() {
    _speech.stop();
  }

  // ✅ Remove Tashkeel (diacritics) from Arabic text
  String removeTashkeel(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F]'), '') // Remove Tashkeel
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .trim();
  }
}
