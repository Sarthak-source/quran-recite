import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false;

  Future<bool> initialize() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      log("❌ Microphone permission denied");
      return false;
    }

    _isInitialized = await _speech.initialize(
      onStatus: (status) => log("📢 Speech Status: $status"),
      onError: (error) => log("⚠️ Speech Error: $error"),
    );

    log("✅ Speech initialized: $_isInitialized");
    return _isInitialized;
  }

  Future<void> listen(Function(String) onResult) async {
    if (!_isInitialized) {
      log("⚠️ SpeechToText not initialized yet! Trying again...");
      _isInitialized = await initialize();
      if (!_isInitialized) {
        log("❌ Speech recognition failed to initialize.");
        return;
      }
    }

    if (!_isListening) {
      _isListening = true;
      log("🎙️ Listening started...");

      _speech.listen(
        onResult: (result) {
          log("📝 Recognized words: ${result.recognizedWords}");
          onResult(result.recognizedWords);
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          partialResults: true,
          onDevice: false, // Change to true for offline mode
        ),
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: "ar",
      );
    } else {
      log("⚠️ Already listening, ignoring...");
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    await _speech.stop();
    _isListening = false;
    log("🛑 Listening stopped.");
  }
}
