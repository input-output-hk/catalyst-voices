import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

/// Exception thrown when an API request fails due to a bad certificate, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message for display in the UI.
final class BadCertificateApiException extends LocalizedApiException {
  const BadCertificateApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorBadCertificate;
  }
}

/// Exception thrown when an API request fails due to a connection error for example by a `xhr.onError` or
/// SocketExceptions, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message for display in the UI.
final class ConnectionErrorApiException extends LocalizedApiException {
  const ConnectionErrorApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorConnectionError;
  }
}

/// Exception thrown when an API request fails with an error response, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message based on [statusCode].
final class ErrorResponseException extends LocalizedApiException {
  final int statusCode;
  final Object? error;

  ErrorResponseException({
    required this.statusCode,
    this.error,
  });

  @override
  List<Object?> get props => [statusCode, error];

  @override
  String message(BuildContext context) {
    return switch (statusCode) {
      ApiResponseStatusCode.notFound => context.l10n.apiErrorNotFound,
      ApiResponseStatusCode.tooManyRequests => context.l10n.apiErrorTooManyRequests,
      ApiResponseStatusCode.internalServerError => context.l10n.apiErrorInternalServerError,
      ApiResponseStatusCode.serviceUnavailable => context.l10n.apiErrorServiceUnavailable,
      _ => context.l10n.apiErrorUnknown,
    };
  }
}

/// Base class for localized API exceptions.
///
/// Class depending on [ApiException] returns a specific [LocalizedApiException].
sealed class LocalizedApiException extends LocalizedException {
  const LocalizedApiException();

  factory LocalizedApiException.from(ApiException source) {
    return switch (source) {
      ApiBadResponseException(:final statusCode, :final error) => ErrorResponseException(
        statusCode: statusCode,
        error: error,
      ),
      ApiMalformedBodyException() => const MalformedBodyApiException(),
      ApiBadCertificateException() => const BadCertificateApiException(),
      ApiConnectionErrorException() => const ConnectionErrorApiException(),
      ApiConnectionTimeoutException() ||
      ApiReceiveTimeoutException() ||
      ApiSendTimeoutException() => const TimeoutApiException(),
      ApiRequestCancelledException() => const RequestCancelledApiException(),
      ApiUnknownException() => const UnknownApiException(),
    };
  }
}

/// Exception thrown when an API request fails with a malformed body, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message for display in the UI.
final class MalformedBodyApiException extends LocalizedApiException {
  const MalformedBodyApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorMalformedBody;
  }
}

/// Exception thrown when an API request is cancelled, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message for display in the UI.
final class RequestCancelledApiException extends LocalizedApiException {
  const RequestCancelledApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorRequestCancelled;
  }
}

/// Exception thrown when an API request times out, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message for display in the UI.
final class TimeoutApiException extends LocalizedApiException {
  const TimeoutApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorTimeout;
  }
}

/// Exception thrown when an API request fails with an unknown error, with localization support.
///
/// This exception is used to indicate that the application was unable to process an API request
/// and provides a localized error message for display in the UI.
final class UnknownApiException extends LocalizedApiException {
  const UnknownApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorUnknown;
  }
}
