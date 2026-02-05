import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeActionCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DateTime? votingSnapshotDate;
  final DocumentRef? profileId;
  final RepresentativeRegistrationStatus registrationStatus;

  const RepresentativeActionCubitCache({
    this.activeAccountId,
    this.votingSnapshotDate,
    this.profileId,
    this.registrationStatus = RepresentativeRegistrationStatus.notRegistered,
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    votingSnapshotDate,
    profileId,
    registrationStatus,
  ];

  RepresentativeActionCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DateTime>? votingSnapshotDate,
    Optional<DocumentRef>? profileId,
    RepresentativeRegistrationStatus? registrationStatus,
  }) {
    return RepresentativeActionCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      votingSnapshotDate: votingSnapshotDate.dataOr(this.votingSnapshotDate),
      profileId: profileId.dataOr(this.profileId),
      registrationStatus: registrationStatus ?? this.registrationStatus,
    );
  }
}
