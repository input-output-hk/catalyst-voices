import 'package:equatable/equatable.dart';

final class RepresentativeActionState extends Equatable {
  final DateTime? votingSnapshotDate;

  const RepresentativeActionState({this.votingSnapshotDate});

  RepresentativeActionState copyWith({
    DateTime? votingSnapshotDate,
  }) {
    return RepresentativeActionState(
      votingSnapshotDate: votingSnapshotDate ?? this.votingSnapshotDate,
    );
  }

  @override
  List<Object?> get props => [
    votingSnapshotDate,
  ];
}
