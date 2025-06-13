import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

final class LocalizedKeychainNotFoundException extends LocalizedRegistrationException {
  const LocalizedKeychainNotFoundException();

  @override
  String message(BuildContext context) {
    return context.l10n.registrationSaveProgressKeychainNotFoundException;
  }
}

final class LocalizedRecoverAccountNotFound extends LocalizedRegistrationException {
  const LocalizedRecoverAccountNotFound();

  @override
  String message(BuildContext context) => context.l10n.registrationAccountNotFound;
}

final class LocalizedRecoverKeychainNotFoundException extends LocalizedRegistrationException {
  const LocalizedRecoverKeychainNotFoundException();

  @override
  String message(BuildContext context) => context.l10n.registrationRecoverKeychainNotFound;
}

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
      RegistrationTransactionException() => const LocalizedRegistrationTransactionException(),
      RegistrationUnknownException() => const LocalizedRegistrationUnknownException(),
      RegistrationNetworkIdMismatchException(:final targetNetworkId) =>
        LocalizedRegistrationNetworkIdMismatchException(
          targetNetworkId: targetNetworkId,
        ),
      RegistrationRecoverKeychainNotFoundException() =>
        const LocalizedRegistrationKeychainNotFoundException(),
    };
  }
}

/// A localized version of [RegistrationInsufficientBalanceException].
final class LocalizedRegistrationInsufficientBalanceException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationInsufficientBalanceException();

  @override
  String message(BuildContext context) => context.l10n.registrationInsufficientBalance(
        CardanoWalletDetails.minAdaForRegistration.ada,
      );
}

final class LocalizedRegistrationKeychainNotFoundException extends LocalizedRegistrationException {
  const LocalizedRegistrationKeychainNotFoundException();

  @override
  String message(BuildContext context) => context.l10n.registrationKeychainNotFound;
}

final class LocalizedRegistrationNetworkIdMismatchException extends LocalizedRegistrationException {
  /// The [NetworkId] that the user should be using.
  final NetworkId targetNetworkId;

  const LocalizedRegistrationNetworkIdMismatchException({
    required this.targetNetworkId,
  });

  @override
  String message(BuildContext context) => context.l10n.registrationNetworkIdMismatch(
        targetNetworkId.localizedName(context),
      );
}

/// Localized exception thrown when attempting to execute register operation
/// which requires seed phrase but non was found.
final class LocalizedRegistrationSeedPhraseNotFoundException
    extends LocalizedRegistrationException {
  const LocalizedRegistrationSeedPhraseNotFoundException();

  @override
  String message(BuildContext context) => context.l10n.registrationSeedPhraseNotFound;
}

/// An exception thrown when submitting a registration transaction fails.
final class LocalizedRegistrationTransactionException extends LocalizedRegistrationException {
  const LocalizedRegistrationTransactionException();

  @override
  String message(BuildContext context) => context.l10n.registrationTransactionFailed;
}

/// A generic error for describing a failure during user registration.
final class LocalizedRegistrationUnknownException extends LocalizedRegistrationException {
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
  String message(BuildContext context) => context.l10n.registrationUnlockPasswordNotFound;
}

final class LocalizedRegistrationWalletNotFoundException extends LocalizedRegistrationException {
  const LocalizedRegistrationWalletNotFoundException();

  @override
  String message(BuildContext context) => context.l10n.registrationWalletNotFound;
}

final class LocalizedSaveRegistrationProgressException extends LocalizedRegistrationException {
  final List<LocalizedException> reasons;

  const LocalizedSaveRegistrationProgressException({
    this.reasons = const [],
  });

  @override
  List<Object?> get props => [reasons];

  @override
  String message(BuildContext context) {
    final buffer = StringBuffer(context.l10n.registrationSaveProgressException);

    final reasons = this.reasons.mapIndexed((index, element) {
      final suffix = index == 0 ? '.' : ',';
      final message = element.message(context);

      return '$suffix $message';
    });

    for (final reason in reasons) {
      buffer.write(reason);
    }

    return buffer.toString();
  }
}

final class LocalizedSeedPhraseNotFoundException extends LocalizedRegistrationException {
  const LocalizedSeedPhraseNotFoundException();

  @override
  String message(BuildContext context) {
    return context.l10n.registrationSaveProgressSeedPhraseNotFoundException;
  }
}

final class LocalizedSeedPhraseWordsDoNotMatchException extends LocalizedRegistrationException {
  const LocalizedSeedPhraseWordsDoNotMatchException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorSeedPhraseWordsDoNotMatch;
  }
}

final class LocalizedUnlockPasswordNotFoundException extends LocalizedRegistrationException {
  const LocalizedUnlockPasswordNotFoundException();

  @override
  String message(BuildContext context) {
    return context.l10n.registrationSaveProgressUnlockPasswordNotFoundException;
  }
}

final class LocalizedWalletLinkException extends LocalizedRegistrationException {
  final WalletApiErrorCode code;

  LocalizedWalletLinkException({
    required this.code,
  });

  @override
  String message(BuildContext context) {
    return switch (code) {
      WalletApiErrorCode.invalidRequest => context.l10n.errorWalletLinkInvalidRequest,
      WalletApiErrorCode.internalError => context.l10n.errorWalletLinkInternalError,
      WalletApiErrorCode.refused => context.l10n.errorWalletLinkRefused,
      WalletApiErrorCode.accountChange => context.l10n.errorWalletLinkAccountChange,
    };
  }
}
