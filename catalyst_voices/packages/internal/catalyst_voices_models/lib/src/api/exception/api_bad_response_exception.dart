part of 'api_exception.dart';

final class ApiBadResponseException extends ApiException {
  /// Http response code
  final int statusCode;

  /// Optional response body.
  ///
  /// It's dynamic changes base on endpoint and status code. That's why it's a [Object].
  final Object? responseBody;

  const ApiBadResponseException({
    required this.statusCode,
    super.message,
    super.uri,
    super.error,
    this.responseBody,
  });

  const ApiBadResponseException.notFound({
    super.message,
    super.uri,
    super.error,
    this.responseBody,
  }) : statusCode = ApiResponseStatusCode.notFound;

  @override
  List<Object?> get props => super.props + [statusCode, responseBody];
}
