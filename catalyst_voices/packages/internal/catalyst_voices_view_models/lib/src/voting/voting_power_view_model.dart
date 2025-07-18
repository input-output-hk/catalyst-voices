import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingPowerViewModel extends Equatable {
  final int power;
  final VotingPowerStatus status;
  final DateTime updatedAt;

  const VotingPowerViewModel({
    required this.power,
    required this.status,
    required this.updatedAt,
  });

  factory VotingPowerViewModel.fromModel(VotingPower votingPower) {
    return VotingPowerViewModel(
      power: votingPower.power,
      status: votingPower.status,
      updatedAt: votingPower.updatedAt,
    );
  }

  @override
  List<Object?> get props => [power, status, updatedAt];
}
