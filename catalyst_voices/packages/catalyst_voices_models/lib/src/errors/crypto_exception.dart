import 'package:equatable/equatable.dart';

sealed class CryptoException extends Equatable implements Exception {
  const CryptoException();

  @override
  List<Object?> get props => [];
}

/// Usually thrown when trying to decrypt with invalid key
final class CryptoAuthenticationException extends CryptoException {
  const CryptoAuthenticationException();
}
