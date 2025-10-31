part of 'api_exception.dart';

final class ApiConnectionErrorException extends ApiException {
  const ApiConnectionErrorException({
    super.message,
    super.uri,
    super.error,
  });
}
