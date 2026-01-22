import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Account voting role is always in context of given [Campaign] because
/// delegation & representation is defined per [Campaign] category.
///
/// By default every account is an [AccountVotingRoleIndividual].
sealed class AccountVotingRole extends Equatable {
  final CatalystId accountId;
  final DocumentRef campaignId;

  const AccountVotingRole({
    required this.accountId,
    required this.campaignId,
  });

  /// Whether this [AccountVotingRole] allows for manual voting.
  bool get isManualVotingEnabled;

  @override
  List<Object?> get props => [
    accountId,
    campaignId,
  ];

  AccountVotingRole copyWith({
    CatalystId? accountId,
    DocumentRef? campaignId,
  });
}

/// Represents valid and active delegator role status of an account.
///
/// If delegation is partially valid this class won't represent such state.
final class AccountVotingRoleDelegator extends AccountVotingRole {
  final Snapshot<VotingPower> votingPower;
  final int representativesCount;

  const AccountVotingRoleDelegator({
    required super.accountId,
    required super.campaignId,
    this.votingPower = const Snapshot.idle(),
    this.representativesCount = 0,
  });

  @override
  bool get isManualVotingEnabled => false;

  @override
  List<Object?> get props =>
      super.props +
      [
        votingPower,
        representativesCount,
      ];

  @override
  AccountVotingRoleDelegator copyWith({
    CatalystId? accountId,
    DocumentRef? campaignId,
    Snapshot<VotingPower>? votingPower,
    int? representativesCount,
  }) {
    return AccountVotingRoleDelegator(
      accountId: accountId ?? this.accountId,
      campaignId: campaignId ?? this.campaignId,
      votingPower: votingPower ?? this.votingPower,
      representativesCount: representativesCount ?? this.representativesCount,
    );
  }
}

/// Default state of every account for any [Campaign].
final class AccountVotingRoleIndividual extends AccountVotingRole {
  final Snapshot<VotingPower> votingPower;

  const AccountVotingRoleIndividual({
    required super.accountId,
    required super.campaignId,
    this.votingPower = const Snapshot.idle(),
  });

  @override
  bool get isManualVotingEnabled => true;

  @override
  List<Object?> get props => super.props + [votingPower];

  @override
  AccountVotingRoleIndividual copyWith({
    CatalystId? accountId,
    DocumentRef? campaignId,
    Snapshot<VotingPower>? votingPower,
  }) {
    return AccountVotingRoleIndividual(
      accountId: accountId ?? this.accountId,
      campaignId: campaignId ?? this.campaignId,
      votingPower: votingPower ?? this.votingPower,
    );
  }
}

/// Represents valid and active representative role status of an account.
///
/// If account has [AccountRole.drep] role and representative profile, but no nomination for
/// [Campaign] categories, this class won't represent such state as it's not active representative.
final class AccountVotingRoleRepresentative extends AccountVotingRole {
  /// Calculating [RepresentativeVotingPower] is expensive and may take while to complete.
  /// That's why we're wrapping it with [Snapshot].
  final Snapshot<RepresentativeVotingPower> votingPower;
  final int delegatorsCount;

  const AccountVotingRoleRepresentative({
    required super.accountId,
    required super.campaignId,
    this.votingPower = const Snapshot.idle(),
    this.delegatorsCount = 0,
  });

  @override
  bool get isManualVotingEnabled => true;

  @override
  List<Object?> get props =>
      super.props +
      [
        votingPower,
        delegatorsCount,
      ];

  @override
  AccountVotingRoleRepresentative copyWith({
    CatalystId? accountId,
    DocumentRef? campaignId,
    Snapshot<RepresentativeVotingPower>? votingPower,
    int? delegatorsCount,
  }) {
    return AccountVotingRoleRepresentative(
      accountId: accountId ?? this.accountId,
      campaignId: campaignId ?? this.campaignId,
      votingPower: votingPower ?? this.votingPower,
      delegatorsCount: delegatorsCount ?? this.delegatorsCount,
    );
  }
}
