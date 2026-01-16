import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ContestDelegationChoice extends Equatable {
  final CatalystId representativeId;
  final DocumentRef nominationId;
  final bool isNominationLatest;
  final bool isRevoked;

  const ContestDelegationChoice({
    required this.representativeId,
    required this.nominationId,
    this.isNominationLatest = true,
    this.isRevoked = false,
  });

  bool get isValid => !isRevoked && isNominationLatest;

  @override
  List<Object?> get props => [
    representativeId,
    nominationId,
    isNominationLatest,
    isRevoked,
  ];

  ContestDelegationChoice copyWith({
    CatalystId? representativeId,
    DocumentRef? nominationId,
    bool? isLatest,
    bool? isRevoked,
  }) {
    return ContestDelegationChoice(
      representativeId: representativeId ?? this.representativeId,
      nominationId: nominationId ?? this.nominationId,
      isNominationLatest: isLatest ?? this.isNominationLatest,
      isRevoked: isRevoked ?? this.isRevoked,
    );
  }
}
