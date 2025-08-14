import 'package:equatable/equatable.dart';

final class VotingPower extends Equatable {
  final int amount;
  final VotingPowerStatus status;
  final DateTime updatedAt;

  const VotingPower({
    required this.amount,
    required this.status,
    required this.updatedAt,
  });

  factory VotingPower.dummy() {
    return VotingPower(
      amount: 1520,
      status: VotingPowerStatus.provisional,
      updatedAt: DateTime.utc(2025, 8, 13, 10, 15),
    );
  }

  @override
  List<Object?> get props => [amount, status, updatedAt];

  VotingPower copyWith({
    int? amount,
    VotingPowerStatus? status,
    DateTime? updatedAt,
  }) {
    return VotingPower(
      amount: amount ?? this.amount,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum VotingPowerStatus {
  /// The voting power may change in the future as it was not yet captured as final.
  ///
  /// Further transactions will affect the voting power.
  provisional,

  /// The voting power is captured as final one. Further transactions don't affect it.
  confirmed,
}
