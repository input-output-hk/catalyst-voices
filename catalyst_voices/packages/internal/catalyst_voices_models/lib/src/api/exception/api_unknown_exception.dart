part of 'api_exception.dart';

final class ApiUnknownException extends ApiException {
  const ApiUnknownException({
    super.message,
    super.uri,
    super.error,
  });
}
