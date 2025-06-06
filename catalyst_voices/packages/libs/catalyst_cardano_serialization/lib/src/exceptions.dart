import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:equatable/equatable.dart';

/// Exception thrown when a native asset that is required
/// does not exist in the wallet.
final class AssetDoesNotExistException extends Equatable implements Exception {
  /// The default constructor for [AssetDoesNotExistException].
  const AssetDoesNotExistException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'AssetDoesNotExistException';
}

/// Exception thrown when parsing a hash that has incorrect length.
final class HashFormatException extends Equatable implements Exception {
  /// Exception details.
  final String? message;

  /// The default constructor for [HashFormatException].
  const HashFormatException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'HashFormatException: $message';
}

/// Exception thrown when there's not enough [Coin] to transfer native assets.
final class InsufficientAdaForAssetsException extends Equatable implements Exception {
  /// The default constructor for [InsufficientAdaForAssetsException].
  const InsufficientAdaForAssetsException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'InsufficientAdaForAssetsException';
}

/// Exception thrown when the transaction outputs exceed the inputs.
final class InsufficientUtxoBalanceException extends Equatable implements Exception {
  /// The amount of [Balance] that user has.
  final Balance actualAmount;

  /// The amount of [Balance] that user wants to spend.
  final Balance requiredAmount;

  /// The default constructor for [InsufficientUtxoBalanceException].
  const InsufficientUtxoBalanceException({
    required this.actualAmount,
    required this.requiredAmount,
  });

  @override
  List<Object?> get props => [actualAmount, requiredAmount];

  @override
  String toString() => 'InsufficientUtxoBalanceException('
      'actualAmount:$actualAmount'
      ', requiredAmount:$requiredAmount'
      ')';
}

/// Exception thrown if the address doesn't match the bech32 specification
/// for Shelley addresses.
final class InvalidAddressException extends Equatable implements Exception {
  /// Exception details.
  final String message;

  /// Default constructor [InvalidAddressException].
  const InvalidAddressException(this.message);

  @override
  List<Object?> get props => [message];

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
final class InvalidTransactionWitnessesException extends Equatable implements Exception {
  /// The default constructor for [InvalidTransactionWitnessesException].
  const InvalidTransactionWitnessesException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'InvalidTransactionWitnessesException';
}

/// Exception thrown when the maximum number of inputs is exceeded.
final class MaximumInputExceededException extends Equatable implements Exception {
  /// The maximum nr of allowed inputs.
  final int maxInputs;

  /// Creates an instance of [MaximumInputExceededException].
  const MaximumInputExceededException({
    required this.maxInputs,
  });

  @override
  List<Object?> get props => [maxInputs];

  @override
  String toString() => 'Maximum input limit exceeded: $maxInputs';
}

/// Exception thrown when the transaction exceeds the allowed maximum size.
final class MaxTxSizeExceededException extends Equatable implements Exception {
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
  List<Object?> get props => [maxTxSize, actualTxSize];

  @override
  String toString() => 'MaxTxSizeExceededException('
      'maxTxSize:$maxTxSize'
      ', actualTxSize:$actualTxSize'
      ')';
}

/// Exception thrown when the total size of reference scripts exceeds the limit.
final class ReferenceScriptSizeLimitExceededException extends Equatable implements Exception {
  /// The maximum size of reference scripts allowed per transaction.
  final int maxRefScriptSize;

  /// The default constructor for [ReferenceScriptSizeLimitExceededException].
  const ReferenceScriptSizeLimitExceededException(this.maxRefScriptSize);

  @override
  List<Object?> get props => [maxRefScriptSize];

  @override
  String toString() => 'Total size of reference scripts exceeds the limit of $maxRefScriptSize '
      'bytes';
}

/// Exception thrown when transaction inputs are not equal to outputs + fee.
final class TxBalanceMismatchException extends Equatable implements Exception {
  /// The total balance of inputs.
  final Balance inputs;

  /// The total balance of outputs.
  final Balance outputs;

  /// The fee for the transaction.
  final Coin fee;

  /// The default constructor for [TxBalanceMismatchException].
  const TxBalanceMismatchException({
    required this.inputs,
    required this.outputs,
    required this.fee,
  });

  @override
  List<Object?> get props => [inputs, outputs, fee];

  @override
  String toString() => 'TxBalanceMismatchException('
      'inputs:$inputs'
      ', outputs:$outputs'
      ', fee:$fee'
      ')';
}

/// Exception thrown when building a transaction that doesn't specify the fee.
final class TxFeeNotSpecifiedException extends Equatable implements Exception {
  /// The default constructor for [TxFeeNotSpecifiedException].
  const TxFeeNotSpecifiedException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'TxFeeNotSpecifiedException';
}

/// Exception thrown when building a transaction that doesn't specify the fee.
final class TxFeeTooSmallException extends Equatable implements Exception {
  /// The actual fee provided in the transaction.
  final Coin actualFee;

  /// The minimum fee for transaction.
  final Coin minFee;

  /// The default constructor for [TxFeeTooSmallException].
  const TxFeeTooSmallException({
    required this.actualFee,
    required this.minFee,
  });

  @override
  List<Object?> get props => [actualFee, minFee];

  @override
  String toString() => 'TxFeeTooSmallException('
      'actualFee=$actualFee'
      ', minFee=$minFee'
      ')';
}

/// Exception thrown when the transaction output amount
/// is less than required by the network.
final class TxValueBelowMinUtxoValueException extends Equatable implements Exception {
  /// The amount of [Coin] in the transaction output.
  final Coin actualAmount;

  /// The amount of [Coin] that is the minimum.
  final Coin requiredAmount;

  /// The default constructor for [TxValueBelowMinUtxoValueException].
  const TxValueBelowMinUtxoValueException({
    required this.actualAmount,
    required this.requiredAmount,
  });

  @override
  List<Object?> get props => [actualAmount, requiredAmount];

  @override
  String toString() => 'TxValueBelowMinUtxoValueException('
      'actualAmount:$actualAmount'
      ', requiredAmount:$requiredAmount'
      ')';
}

/// Exception thrown when the transaction output
/// takes more bytes than allowed by [maxValueSize].
final class TxValueSizeExceededException extends Equatable implements Exception {
  /// The size in bytes that the value has.
  final int actualValueSize;

  /// The maximum allowed value size.
  final int maxValueSize;

  /// The default constructor for [TxValueSizeExceededException].
  const TxValueSizeExceededException({
    required this.actualValueSize,
    required this.maxValueSize,
  });

  @override
  List<Object?> get props => [actualValueSize, maxValueSize];

  @override
  String toString() => 'TxValueSizeExceededException('
      'actualValueSize:$actualValueSize'
      ', maxValueSize:$maxValueSize'
      ')';
}

/// Exception thrown when the transaction output
/// has more native tokens than allowed.
final class TxMaxAssetsPerOutputExceededException extends Equatable implements Exception {
  /// The current native tokens count.
  final int actualCount;

  /// The maximum allowed count.
  final int maxCount;

  /// The default constructor for [TxMaxAssetsPerOutputExceededException].
  const TxMaxAssetsPerOutputExceededException({
    required this.actualCount,
    required this.maxCount,
  });

  @override
  List<Object?> get props => [actualCount, maxCount];

  @override
  String toString() => 'TxMaxAssetsPerOutputExceededException('
      'actualCount:$actualCount'
      ', maxCount:$maxCount'
      ')';
}
