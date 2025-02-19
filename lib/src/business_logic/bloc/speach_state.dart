abstract class SpeechState {}

class SpeechInitial extends SpeechState {}

class SpeechListening extends SpeechState {}

class SpeechSuccess extends SpeechState {
  final String recognizedWords;
  final List<bool> wordMatches;

  SpeechSuccess(this.recognizedWords, this.wordMatches);
}

class SpeechError extends SpeechState {
  final String message;
  SpeechError(this.message);
}
