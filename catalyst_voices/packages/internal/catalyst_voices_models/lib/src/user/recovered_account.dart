import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines singular recovered account used by [User] (physical person).
/// The class should contain all possible data fields known about the user.
final class RecoveredAccount extends Equatable {
  final String? username;
  final String? email;
  final Set<AccountRole> roles;
  final ShelleyAddress stakeAddress;
  final AccountPublicStatus publicStatus;

  const RecoveredAccount({
    required this.username,
    required this.email,
    required this.roles,
    required this.stakeAddress,
    required this.publicStatus,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        roles,
        stakeAddress,
        publicStatus,
      ];
}
