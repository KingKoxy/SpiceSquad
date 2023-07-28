import "dart:io";

import "package:http/http.dart";

/// Exception that is thrown when a http request fails
class HttpStatusException implements HttpException {
  /// The status code of the response
  final Response response;

  /// Creates a new [HttpStatusException] from the given [response]
  HttpStatusException(this.response);

  @override
  String toString() {
    return "HttpStatusException:\n\turi: $uri\n\t$statusCode: $message";
  }

  @override
  String get message => response.body;

  @override
  Uri get uri => response.request?.url ?? Uri();

  /// The status code of the response
  int get statusCode => response.statusCode;
}
