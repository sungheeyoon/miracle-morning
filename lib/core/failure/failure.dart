class Failure {
  final String message;
  final StackTrace? stackTrace;

  Failure(this.message, [this.stackTrace]);

  @override
  String toString() => 'Failure: $message\n${stackTrace ?? ''}';
}

class AppFailure {
  final String message;
  AppFailure([this.message = 'An unexpected error occurred!']);

  @override
  String toString() => 'AppFailure(message: $message)';
}
