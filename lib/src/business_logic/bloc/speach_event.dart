abstract class SpeechEvent {}

class StartListening extends SpeechEvent {
  final List<String> targetWords;
  StartListening(this.targetWords);
}

class StopListening extends SpeechEvent {}

class SpeechRecognized extends SpeechEvent {
  final String recognizedWords;
  final List<String> targetWords;

  SpeechRecognized(this.recognizedWords, this.targetWords);
}
