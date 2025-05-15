import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

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
      ApiErrorResponseException.notFound => context.l10n.apiErrorNotFound,
      ApiErrorResponseException.tooManyRequests => context.l10n.apiErrorTooManyRequests,
      ApiErrorResponseException.internalServerError => context.l10n.apiErrorInternalServerError,
      ApiErrorResponseException.serviceUnavailable => context.l10n.apiErrorServiceUnavailable,
      _ => context.l10n.apiErrorUnknown,
    };
  }
}

sealed class LocalizedApiException extends LocalizedException {
  const LocalizedApiException();

  factory LocalizedApiException.from(ApiException source) {
    return switch (source) {
      ApiErrorResponseException(:final statusCode, :final error) => ErrorResponseException(
          statusCode: statusCode,
          error: error,
        ),
      ApiMalformedBodyException() => const MalformedBodyApiException(),
    };
  }
}

final class MalformedBodyApiException extends LocalizedApiException {
  const MalformedBodyApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorMalformedBody;
  }
}

final class UnknownApiException extends LocalizedApiException {
  const UnknownApiException();

  @override
  String message(BuildContext context) {
    return context.l10n.apiErrorUnknown;
  }
}
