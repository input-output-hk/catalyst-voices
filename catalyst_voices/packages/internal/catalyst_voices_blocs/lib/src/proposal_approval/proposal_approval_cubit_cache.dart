import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalApprovalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final List<CollaboratorProposalDisplayConsent> proposalsDisplayConsent;

  const ProposalApprovalCubitCache({
    this.activeAccountId,
    this.proposalsDisplayConsent = const [],
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    proposalsDisplayConsent,
  ];

  ProposalApprovalCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    List<CollaboratorProposalDisplayConsent>? proposalsDisplayConsent,
  }) {
    return ProposalApprovalCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      proposalsDisplayConsent: proposalsDisplayConsent ?? this.proposalsDisplayConsent,
    );
  }
}
