import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

/// A base exception thrown during user registration.
sealed class RegistrationException with EquatableMixin implements Exception {
  const RegistrationException();

  @override
  List<Object?> get props => [];
}

/// An exception thrown when attempting to register
/// but the user doesn't have enough Ada to cover the transaction fee.
final class RegistrationInsufficientBalanceException extends RegistrationException {
  const RegistrationInsufficientBalanceException();

  @override
  String toString() => 'RegistrationInsufficientBalanceException';
}

/// An exception thrown when wallet ID doesn't match the configured network ID.
///
/// I.e. trying to create transaction on preprod with production wallet.
final class RegistrationNetworkIdMismatchException extends RegistrationException {
  /// The [NetworkId] that the user should be using.
  final NetworkId targetNetworkId;

  const RegistrationNetworkIdMismatchException({required this.targetNetworkId});

  @override
  List<Object?> get props => [targetNetworkId];

  @override
  String toString() => 'RegistrationNetworkIdMismatchException(target: $targetNetworkId)';
}

/// An exception thrown when attempting to register and the transaction fails.
final class RegistrationTransactionException extends RegistrationException {
  const RegistrationTransactionException();

  @override
  String toString() => 'RegistrationTransactionException';
}

/// An exception thrown when recovering registration but keychain was not found locally.
final class RegistrationRecoverKeychainNotFoundException extends RegistrationException {
  const RegistrationRecoverKeychainNotFoundException();

  @override
  String toString() => 'RegistrationRecoverKeychainNotFoundException';
}

/// An exception thrown when attempting to register and the transaction fails.
final class RegistrationUnknownException extends RegistrationException {
  const RegistrationUnknownException();

  @override
  String toString() => 'RegistrationUnknownException';
}
