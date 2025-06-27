part of 'api_exception.dart';

/// Api did response but status code is not >=200 <300.
final class ApiErrorResponseException extends ApiException {
  /// Http response code
  final int statusCode;

  /// Optional response body.
  ///
  /// It's dynamic changes base on endpoint and status code. That's why it's a [Object].
  final Object? error;

  const ApiErrorResponseException({
    required this.statusCode,
    this.error,
  });

  const ApiErrorResponseException.notFound([this.error])
      : statusCode = ApiResponseStatusCode.notFound;

  @override
  List<Object?> get props => [statusCode, error];

  @override
  String toString() {
    final error = this.error;
    return error == null
        ? 'ApiErrorResponse with statusCode: $statusCode'
        : 'ApiErrorResponse with statusCode: $statusCode and error $error';
  }
}
