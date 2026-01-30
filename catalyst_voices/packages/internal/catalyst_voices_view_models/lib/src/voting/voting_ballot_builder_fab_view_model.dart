import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotBuilderFabViewModel extends Equatable {
  final int count;
  final bool isVisible;
  final bool useGradient;

  const VotingBallotBuilderFabViewModel({
    this.count = 0,
    this.isVisible = false,
    this.useGradient = false,
  });

  factory VotingBallotBuilderFabViewModel.build({
    int ballotBuilderCount = 0,
    AccountVotingRole? votingRole,
    Campaign? campaign,
  }) {
    final isManualVotingEnabled = votingRole?.isManualVotingEnabled ?? false;
    final isVotingActive = campaign?.isVotingActive() ?? false;

    return VotingBallotBuilderFabViewModel(
      count: ballotBuilderCount,
      isVisible: isManualVotingEnabled && isVotingActive,
      useGradient: votingRole != null && votingRole is! AccountVotingRoleIndividual,
    );
  }

  @override
  List<Object?> get props => [
    count,
    isVisible,
    useGradient,
  ];

  VotingBallotBuilderFabViewModel copyWith({
    int? count,
    bool? isVisible,
    bool? useGradient,
  }) {
    return VotingBallotBuilderFabViewModel(
      count: count ?? this.count,
      isVisible: isVisible ?? this.isVisible,
      useGradient: useGradient ?? this.useGradient,
    );
  }
}
