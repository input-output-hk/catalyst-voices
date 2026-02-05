import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Empty state view model.
final class EmptyVotingRoleViewModel extends VotingRoleViewModel {
  const EmptyVotingRoleViewModel();

  @override
  List<Object?> get props => [];
}

/// See [AccountVotingRole].
sealed class VotingRoleViewModel extends Equatable {
  const VotingRoleViewModel();

  factory VotingRoleViewModel.fromModel(AccountVotingRole votingRole) {
    return switch (votingRole) {
      AccountVotingRoleDelegator() => VotingRoleViewModelDelegator.fromModel(votingRole),
      AccountVotingRoleIndividual() => VotingRoleViewModelIndividual.fromModel(votingRole),
      AccountVotingRoleRepresentative() => VotingRoleViewModelRepresentative.fromModel(votingRole),
    };
  }
}

/// See [AccountVotingRoleDelegator].
final class VotingRoleViewModelDelegator extends VotingRoleViewModel {
  final VotingPowerViewModel votingPower;
  final int representativesCount;

  const VotingRoleViewModelDelegator({
    this.votingPower = const VotingPowerViewModel(),
    this.representativesCount = 0,
  });

  factory VotingRoleViewModelDelegator.fromModel(AccountVotingRoleDelegator model) {
    return VotingRoleViewModelDelegator(
      votingPower: VotingPowerViewModel.fromSnapshot(model.votingPower),
      representativesCount: model.representativesCount,
    );
  }

  @override
  List<Object?> get props => [
    votingPower,
    representativesCount,
  ];
}

/// See [AccountVotingRoleIndividual].
final class VotingRoleViewModelIndividual extends VotingRoleViewModel {
  final VotingPowerViewModel votingPower;

  const VotingRoleViewModelIndividual({
    this.votingPower = const VotingPowerViewModel(),
  });

  factory VotingRoleViewModelIndividual.fromModel(AccountVotingRoleIndividual model) {
    return VotingRoleViewModelIndividual(
      votingPower: VotingPowerViewModel.fromSnapshot(model.votingPower),
    );
  }

  @override
  List<Object?> get props => [votingPower];
}

/// See [AccountVotingRoleRepresentative].
final class VotingRoleViewModelRepresentative extends VotingRoleViewModel {
  final VotingPowerViewModel totalVotingPower;
  final VotingPowerViewModel ownVotingPower;
  final VotingPowerViewModel delegatedVotingPower;
  final int delegatorsCount;

  const VotingRoleViewModelRepresentative({
    this.totalVotingPower = const VotingPowerViewModel(),
    this.ownVotingPower = const VotingPowerViewModel(),
    this.delegatedVotingPower = const VotingPowerViewModel(),
    this.delegatorsCount = 0,
  });

  factory VotingRoleViewModelRepresentative.fromModel(AccountVotingRoleRepresentative model) {
    final ownVotingPower = model.votingPower.data?.own;
    final delegatedVotingPower = model.votingPower.data?.delegated;
    final totalVotingPower = VotingPowerViewModel.totalFromModels(
      ownVotingPower,
      delegatedVotingPower,
    );

    return VotingRoleViewModelRepresentative(
      totalVotingPower: totalVotingPower,
      ownVotingPower: ownVotingPower != null
          ? VotingPowerViewModel.fromModel(ownVotingPower)
          : const VotingPowerViewModel(),
      delegatedVotingPower: delegatedVotingPower != null
          ? VotingPowerViewModel.fromModel(delegatedVotingPower)
          : const VotingPowerViewModel(),
      delegatorsCount: model.delegatorsCount,
    );
  }

  @override
  List<Object?> get props => [
    totalVotingPower,
    ownVotingPower,
    delegatedVotingPower,
    delegatorsCount,
  ];
}
