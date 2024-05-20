import 'package:catalyst_cardano_serialization/src/types.dart';

/// Exception thrown when the transaction exceeds the allowed maximum size.
final class MaxTxSizeExceededException implements Exception {
  /// The maximum amount of bytes per transaction.
  final int maxTxSize;

  /// The amount of bytes of transaction that exceeded it's maximum size.
  final int actualTxSize;

  /// The default constructor for [MaxTxSizeExceededException].
  const MaxTxSizeExceededException({
    required this.maxTxSize,
    required this.actualTxSize,
  });

  @override
  String toString() => 'MaxTxSizeExceededException('
      'maxTxSize:$maxTxSize'
      ', actualTxSize:$actualTxSize'
      ')';
}

/// Exception thrown when the transaction outputs exceed the inputs.
final class InsufficientUtxoBalanceException implements Exception {
  /// The amount of [Coin] that user has.
  final Coin actualAmount;

  /// The amount of [Coin] that user wants to spend.
  final Coin requiredAmount;

  /// The default constructor for [InsufficientUtxoBalanceException].
  const InsufficientUtxoBalanceException({
    required this.actualAmount,
    required this.requiredAmount,
  });

  @override
  String toString() => 'InsufficientUtxoBalanceException('
      'actualAmount:$actualAmount'
      ', requiredAmount:$requiredAmount'
      ')';
}

/// Exception thrown when building a transaction that doesn't specify the fee.
final class TxFeeNotSpecifiedException implements Exception {
  /// The default constructor for [TxFeeNotSpecifiedException].
  const TxFeeNotSpecifiedException();

  @override
  String toString() => 'TxFeeNotSpecifiedException';
}

/// Exception thrown when parsing a hash that has incorrect length.
final class HashFormatException implements Exception {
  /// The default constructor for [HashFormatException].
  const HashFormatException();

  @override
  String toString() => 'HashFormatException';
}

/// Exception thrown if the address doesn't match the bech32 specification
/// for Shelley addresses.
final class InvalidAddressException implements Exception {
  /// Exception details.
  final String message;

  /// Default constructor [InvalidAddressException].
  const InvalidAddressException(this.message);

  @override
  String toString() => 'InvalidAddressException: $message';
}

/// Exception thrown when the number of witnesses doesn't match
/// the expected amount.
///
/// When calculating the fee for the transaction the amount of witnesses
/// needs to be specified since they affect the transaction bytes length.
/// 
/// Thus less or more witnesses than were included when calculating
/// the fee are not allowed.
final class InvalidTransactionWitnessesException implements Exception {
  /// The default constructor for [InvalidTransactionWitnessesException].
  const InvalidTransactionWitnessesException();

  @override
  String toString() => 'InvalidTransactionWitnessesException';
}
