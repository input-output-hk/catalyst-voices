import 'package:equatable/equatable.dart';

/// A base exception thrown during user registration.
sealed class RegistrationException with EquatableMixin implements Exception {
  const RegistrationException();

  @override
  List<Object?> get props => [];
}

/// An exception thrown when attempting to register
/// but the user doesn't have enough Ada to cover the transaction fee.
final class RegistrationInsufficientBalanceException
    extends RegistrationException {
  const RegistrationInsufficientBalanceException();

  @override
  String toString() => 'RegistrationInsufficientBalanceException';
}

/// An exception thrown when attempting to register and the transaction fails.
final class RegistrationTransactionException extends RegistrationException {
  const RegistrationTransactionException();

  @override
  String toString() => 'RegistrationTransactionException';
}

/// An exception thrown when attempting to register and the transaction fails.
final class RegistrationUnknownException extends RegistrationException {
  const RegistrationUnknownException();

  @override
  String toString() => 'RegistrationUnknownException';
}
