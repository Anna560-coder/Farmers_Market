class ModelMessage {
  final bool isPrompt;
  final String message;
  final String? originalMessage;
  final DateTime time;

  ModelMessage({
    required this.isPrompt,
    required this.message,
    this.originalMessage,
    required this.time,
  });
}
