part of 'api_exception.dart';

final class ApiRequestCancelledException extends ApiException {
  const ApiRequestCancelledException({
    super.message,
    super.uri,
    super.error,
  });
}
