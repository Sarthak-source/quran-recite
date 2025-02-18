abstract class SpeechState {}

class SpeechInitial extends SpeechState {}

class SpeechListening extends SpeechState {}

class SpeechSuccess extends SpeechState {
  final String recognizedWords; // Store recognized speech
  final List<bool> wordMatches; // Track correctness per word
  SpeechSuccess(this.recognizedWords,this.wordMatches);
}
class SpeechError extends SpeechState {
  final String message;
  SpeechError(this.message);
}