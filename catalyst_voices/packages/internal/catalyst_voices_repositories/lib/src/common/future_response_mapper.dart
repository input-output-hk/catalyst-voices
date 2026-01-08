import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension FutureResponseMapper<T> on Future<T> {
  /// Returns the [T] body from the response
  /// or throws an exception if the response wasn't successful.
  Future<T> successBodyOrThrow() async {
    try {
      final response = await this;
      return response;
    } catch (e) {
      if (e case ApiBadResponseException(:final statusCode)) {
        final message = _extractExceptionMessage(e);
        if (statusCode == ApiResponseStatusCode.notFound) {
          throw NotFoundException(message: message);
        } else if (statusCode == ApiResponseStatusCode.unauthorized) {
          throw UnauthorizedException(message: message);
        } else if (statusCode == ApiResponseStatusCode.forbidden) {
          throw ForbiddenException(message: message);
        } else if (statusCode == ApiResponseStatusCode.conflict) {
          throw ResourceConflictException(message: message);
        }
      }
      rethrow;
    }
  }

  String? _extractExceptionMessage(ApiException exception) {
    return exception.message ?? exception.error?.toString();
  }
}
