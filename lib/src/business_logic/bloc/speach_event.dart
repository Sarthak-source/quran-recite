abstract class SpeechEvent {}

class StartListening extends SpeechEvent {
  final List<String> targetWords; // ✅ Now supports multiple lines
  StartListening(this.targetWords);
}

class StopListening extends SpeechEvent {}

class SpeechRecognized extends SpeechEvent {
  final String recognizedWords;
  final List<String> targetWords; // ✅ Change targetWord to List

  SpeechRecognized(this.recognizedWords, this.targetWords);
}