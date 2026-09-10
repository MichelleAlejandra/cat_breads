/// Outcome of a [CoreHttp] request: either [HttpSuccess] with the parsed
/// data, or [HttpFailure] describing what went wrong.
sealed class HttpResult<T> {
  const HttpResult();
}

class HttpSuccess<T> extends HttpResult<T> {
  const HttpSuccess(this.data);

  final T data;
}

class HttpFailure<T> extends HttpResult<T> {
  const HttpFailure(this.reason, {this.statusCode, this.message});

  final HttpFailureReason reason;
  final int? statusCode;
  final String? message;
}

enum HttpFailureReason {
  /// No internet connection / the host couldn't be reached.
  network,

  /// The request didn't complete in time.
  timeout,

  /// The server responded with a non-2xx status code.
  server,

  /// The response body couldn't be decoded or mapped to the expected model.
  parsing,

  /// Anything else not covered above.
  unknown,
}
