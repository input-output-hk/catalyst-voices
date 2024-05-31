/// Exception thrown when signing the transaction fails.
final class TxSignException implements Exception {
  /// The default constructor for [TxSignException].
  const TxSignException();

  @override
  String toString() => 'TxSignException';
}

/// Exception thrown when submitting the transaction fails.
final class TxSendException implements Exception {
  /// The default constructor for [TxSendException].
  const TxSendException();

  @override
  String toString() => 'TxSendException';
}
