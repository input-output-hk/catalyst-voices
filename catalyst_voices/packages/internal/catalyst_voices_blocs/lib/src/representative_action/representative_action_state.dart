import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeActionState extends Equatable {
  final DateTime? votingSnapshotDate;
  final StepBackRepresentativeActionStep? additionalStep;
  final List<RepresentativeActionStep> representativeActions;
  final RepresentativeRegistrationStatus? registrationStatus;

  const RepresentativeActionState({
    this.votingSnapshotDate,
    this.additionalStep,
    this.representativeActions = const [],
    this.registrationStatus,
  });

  @override
  List<Object?> get props => [
    votingSnapshotDate,
    additionalStep,
    representativeActions,
    registrationStatus,
  ];

  RepresentativeActionState copyWith({
    DateTime? votingSnapshotDate,
    Optional<StepBackRepresentativeActionStep>? additionalStep,
    List<RepresentativeActionStep>? representativeActions,
    Optional<RepresentativeRegistrationStatus>? registrationStatus,
  }) {
    return RepresentativeActionState(
      votingSnapshotDate: votingSnapshotDate ?? this.votingSnapshotDate,
      additionalStep: additionalStep.dataOr(this.additionalStep),
      representativeActions: representativeActions ?? this.representativeActions,
      registrationStatus: registrationStatus.dataOr(this.registrationStatus),
    );
  }
}
