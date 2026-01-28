import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines singular recoverable account used by the [User] (physical person).
/// The class should contain all possible data fields known about the user.
final class RecoverableAccount extends Equatable {
  final String? username;
  final String? email;
  final Set<AccountRole> roles;
  final ShelleyAddress stakeAddress;
  final AccountPublicStatus publicStatus;
  final bool isPersistent;

  const RecoverableAccount({
    required this.username,
    required this.email,
    required this.roles,
    required this.stakeAddress,
    required this.publicStatus,
    required this.isPersistent,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    roles,
    stakeAddress,
    publicStatus,
    isPersistent,
  ];
}
