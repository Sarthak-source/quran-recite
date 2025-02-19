import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false; // Track if initialized

  Future<bool> initialize() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      print("❌ Microphone permission denied");
      return false;
    }

    _isInitialized = await _speech.initialize(
      onStatus: (status) => print("📢 Speech Status: $status"),
      onError: (error) => print("⚠️ Speech Error: $error"),
    );

    print("✅ Speech initialized: $_isInitialized");
    return _isInitialized;
  }

  void listen(Function(String) onResult) async {
    if (!_isInitialized) {
      print("⚠️ SpeechToText not initialized yet! Trying again...");
      _isInitialized = await initialize();
      if (!_isInitialized) {
        print("❌ Speech recognition failed to initialize.");
        return;
      }
    }

    if (_isListening) {
      print("⚠️ Already listening, ignoring...");
      return;
    }

    _isListening = true;
    print("🎙️ Listening started...");

    _speech.listen(
      onResult: (result) {
        print("📝 Recognized words: ${result.recognizedWords}");
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(minutes: 10), // Keep listening for a long time
      pauseFor: const Duration(seconds: 1000), // Allow pauses in speech
      localeId: "ar",
      //listenMode:
    );
  }

  void stopListening() {
    if (!_isListening) return;

    _speech.stop();
    _isListening = false;
    print("🛑 Listening stopped.");
  }
}