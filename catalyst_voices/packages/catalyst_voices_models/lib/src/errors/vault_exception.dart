import 'package:equatable/equatable.dart';

sealed class VaultException extends Equatable implements Exception {
  const VaultException();

  @override
  List<Object?> get props => [];
}

final class LockNotFoundException extends VaultException {
  final String? message;

  const LockNotFoundException([this.message]);

  @override
  String toString() {
    if (message != null) return 'LockNotFoundException: $message';
    return 'LockNotFoundException';
  }
}

final class VaultLockedException extends VaultException {
  const VaultLockedException();

  @override
  String toString() => 'VaultLockedException';
}
