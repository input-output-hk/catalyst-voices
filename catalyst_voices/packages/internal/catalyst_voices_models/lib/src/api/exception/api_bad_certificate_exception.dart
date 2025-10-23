part of 'api_exception.dart';

final class ApiBadCertificateException extends ApiException {
  const ApiBadCertificateException({
    super.message,
    super.uri,
    super.error,
  });
}
