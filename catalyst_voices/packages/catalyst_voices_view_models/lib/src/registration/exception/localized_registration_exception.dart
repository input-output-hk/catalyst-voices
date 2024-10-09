import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/widgets.dart';

/// A [LocalizedException] describing an error during a user registration.
abstract base class LocalizedRegistrationException extends LocalizedException {
  const LocalizedRegistrationException();

  /// Creates a subclass of [LocalizedException] matching the [exception].
  factory LocalizedRegistrationException.from(
    RegistrationException exception,
  ) {
    if (exception is RegistrationInsufficientBalanceException) {
      return const LocalizedRegistrationInsufficientBalanceException();
    } else if (exception is RegistrationTransactionException) {
      return const LocalizedRegistrationTransactionException();
    }

    return const LocalizedRegistrationUnknownException();
  }
}

/// A localized version of [RegistrationInsufficientBalanceException].
final class LocalizedRegistrationInsufficientBalanceException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationInsufficientBalanceException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationInsufficientBalance;
}

/// An exception thrown when submitting a registration transaction fails.
final class LocalizedRegistrationTransactionException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationTransactionException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationTransactionFailed;
}

/// A generic error for describing a failure during user registration.
final class LocalizedRegistrationUnknownException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationUnknownException();

  @override
  String message(BuildContext context) => context.l10n.somethingWentWrong;
}
