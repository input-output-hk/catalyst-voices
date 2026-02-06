import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class DisplayConsentCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final List<CollaboratorProposalDisplayConsent> proposalsDisplayConsent;

  const DisplayConsentCubitCache({
    this.activeAccountId,
    this.proposalsDisplayConsent = const [],
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    proposalsDisplayConsent,
  ];

  DisplayConsentCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    List<CollaboratorProposalDisplayConsent>? proposalsDisplayConsent,
  }) {
    return DisplayConsentCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      proposalsDisplayConsent: proposalsDisplayConsent ?? this.proposalsDisplayConsent,
    );
  }
}
