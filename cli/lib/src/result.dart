/// Result bean
class EvaluateResult {
  /// text message.
  final String message;

  /// evaluate state.
  final bool success;

  /// url of local server.
  final String url;

  /// New instance
  EvaluateResult({this.message, this.success, this.url});
}
