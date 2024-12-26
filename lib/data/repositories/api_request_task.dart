final class ApiRequestTask<T> {
  final bool isSuccessful;
  final int httpStatusCode;
  final T? response;
  final Exception? exception;

  ApiRequestTask({
    required this.isSuccessful,
    required this.httpStatusCode,
    this.response,
    this.exception,
  }) : assert((response == null) != (exception == null),
            'Either response or exception must be non-null, but not both.');
}
