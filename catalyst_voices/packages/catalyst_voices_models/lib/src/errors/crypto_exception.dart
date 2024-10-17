import 'package:equatable/equatable.dart';

sealed class CryptoException extends Equatable implements Exception {
  const CryptoException();

  @override
  List<Object?> get props => [];
}

/// Usually thrown when trying to decrypt with invalid key
final class CryptoAuthenticationException extends CryptoException {
  const CryptoAuthenticationException();

  @override
  String toString() => 'CryptoAuthenticationException';
}

/// Thrown when trying to decrypt tampered data
final class CryptoDataMalformed extends CryptoException {
  final String? message;

  const CryptoDataMalformed([this.message]);

  @override
  String toString() {
    if (message != null) return 'CryptoDataMalformed: $message';
    return 'CryptoDataMalformed';
  }
}

final class CryptoVersionUnsupported extends CryptoException {
  final String? message;

  const CryptoVersionUnsupported([this.message]);

  @override
  String toString() {
    if (message != null) return 'CryptoVersionUnsupported: $message';
    return 'CryptoVersionUnsupported';
  }
}

final class CryptoAlgorithmUnsupported extends CryptoException {
  final String? message;

  const CryptoAlgorithmUnsupported([this.message]);

  @override
  String toString() {
    if (message != null) return 'CryptoAlgorithmUnsupported: $message';
    return 'CryptoAlgorithmUnsupported';
  }
}
