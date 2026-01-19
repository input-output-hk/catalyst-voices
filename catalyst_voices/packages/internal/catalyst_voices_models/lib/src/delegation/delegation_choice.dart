import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Represents a specific choice made within a delegation.
final class DelegationChoice extends Equatable {
  /// The unique identifier of the representative chosen.
  final CatalystId representativeId;

  /// The unique identifier of the representative profile document of [representativeId].
  final DocumentRef representativeProfileId;

  /// Indicates whether the [representativeProfileId] is latest version from [representativeId].
  final bool isProfileLatestVer;

  /// Creates a [DelegationChoice].
  const DelegationChoice({
    required this.representativeId,
    required this.representativeProfileId,
    this.isProfileLatestVer = true,
  });

  /// Checks if the choice is valid.
  ///
  /// A choice is considered valid if it is not revoked and refers to the latest nomination.
  bool get isValid => isProfileLatestVer;

  @override
  List<Object?> get props => [
    representativeId,
    representativeProfileId,
    isProfileLatestVer,
  ];

  DelegationChoice copyWith({
    CatalystId? representativeId,
    DocumentRef? representativeProfileId,
    bool? isProfileLatest,
  }) {
    return DelegationChoice(
      representativeId: representativeId ?? this.representativeId,
      representativeProfileId: representativeProfileId ?? this.representativeProfileId,
      isProfileLatestVer: isProfileLatest ?? this.isProfileLatestVer,
    );
  }
}
