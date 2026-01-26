import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AccountKeychainLockedException extends Equatable implements Exception {
  final CatalystId id;

  const AccountKeychainLockedException(this.id);

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'AccountKeychainLockedException(accountId: $id)';
}
