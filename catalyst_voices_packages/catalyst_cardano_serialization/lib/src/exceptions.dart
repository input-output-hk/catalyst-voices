/// Exception thrown when the transaction exceeds the allowed maximum size.
class MaxTxSizeExceededException implements Exception {
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
  String toString() {
    return 'MaxTxSizeExceededException('
        'maxTxSize=$maxTxSize'
        ', actualTxSize:$actualTxSize'
        ')';
  }
}

/// Exception thrown when building a transaction that doesn't specify the fee.
class TxFeeNotSpecifiedException implements Exception {
  /// The default constructor for [TxFeeNotSpecifiedException].
  const TxFeeNotSpecifiedException();

  @override
  String toString() {
    return 'TxFeeNotSpecifiedException';
  }
}

/// Exception thrown when parsing a transaction hash that has incorrect length.
class TransactionHashFormatException implements Exception {
  /// The default constructor for [TransactionHashFormatException].
  const TransactionHashFormatException();

  @override
  String toString() {
    return 'TransactionHashFormatException';
  }
}

/// Exception thrown if the address doesn't match the bech32 specification
/// for Shelley addresses.
class InvalidAddressException implements Exception {
  /// Exception details.
  final String message;

  /// Default constructor [InvalidAddressException].
  const InvalidAddressException(this.message);

  @override
  String toString() => 'InvalidAddressException: $message';
}
