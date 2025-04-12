import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:catalyst_voices_view_models/src/registration/network_id_ext.dart';
import 'package:flutter/widgets.dart';

/// A [LocalizedException] describing an error during a user registration.
sealed class LocalizedRegistrationException extends LocalizedException {
  const LocalizedRegistrationException();

  /// Creates a subclass of [LocalizedException] matching the [exception].
  factory LocalizedRegistrationException.from(
    RegistrationException exception,
  ) {
    return switch (exception) {
      RegistrationInsufficientBalanceException() =>
        const LocalizedRegistrationInsufficientBalanceException(),
      RegistrationTransactionException() =>
        const LocalizedRegistrationTransactionException(),
      RegistrationUnknownException() =>
        const LocalizedRegistrationUnknownException(),
      RegistrationNetworkIdMismatchException(:final targetNetworkId) =>
        LocalizedRegistrationNetworkIdMismatchException(
          targetNetworkId: targetNetworkId,
        ),
    };
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

final class LocalizedRegistrationKeychainNotFoundException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationKeychainNotFoundException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationKeychainNotFound;
}

final class LocalizedRegistrationNetworkIdMismatchException
    extends LocalizedRegistrationException {
  /// The [NetworkId] that the user should be using.
  final NetworkId targetNetworkId;

  const LocalizedRegistrationNetworkIdMismatchException({
    required this.targetNetworkId,
  });

  @override
  String message(BuildContext context) =>
      context.l10n.registrationNetworkIdMismatch(
        targetNetworkId.localizedName(context),
      );
}

/// Localized exception thrown when attempting to execute register operation
/// which requires seed phrase but non was found.
final class LocalizedRegistrationSeedPhraseNotFoundException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationSeedPhraseNotFoundException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationSeedPhraseNotFound;
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

/// Localized exception thrown when attempting to execute register operation
/// which requires unlock password but non was found.
final class LocalizedRegistrationUnlockPasswordNotFoundException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationUnlockPasswordNotFoundException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationUnlockPasswordNotFound;
}

final class LocalizedRegistrationWalletNotFoundException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationWalletNotFoundException();

  @override
  String message(BuildContext context) =>
      context.l10n.registrationWalletNotFound;
}

final class LocalizedWalletLinkException
    extends LocalizedRegistrationException {
  final WalletApiErrorCode code;

  LocalizedWalletLinkException({
    required this.code,
  });

  @override
  String message(BuildContext context) {
    return switch (code) {
      WalletApiErrorCode.invalidRequest =>
        context.l10n.errorWalletLinkInvalidRequest,
      WalletApiErrorCode.internalError =>
        context.l10n.errorWalletLinkInternalError,
      WalletApiErrorCode.refused => context.l10n.errorWalletLinkRefused,
      WalletApiErrorCode.accountChange =>
        context.l10n.errorWalletLinkAccountChange,
    };
  }
}
