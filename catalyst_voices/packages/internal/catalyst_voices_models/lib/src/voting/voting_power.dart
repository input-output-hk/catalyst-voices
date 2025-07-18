import 'package:equatable/equatable.dart';

final class VotingPower extends Equatable {
  final int power;
  final VotingPowerStatus status;
  final DateTime updatedAt;

  const VotingPower({
    required this.power,
    required this.status,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [power, status, updatedAt];
}

enum VotingPowerStatus {
  /// The voting power may change in the future as it was not yet captured as final.
  ///
  /// Further transactions will affect the voting power.
  provisional,

  /// The voting power is captured as final one. Further transactions don't affect it.
  confirmed,
}
