import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Proposal-specific metadata used across segment building.
final class ProposalMetadataSegmentData extends Equatable {
  /// The proposal document to build segments for.
  final ProposalDocument proposal;

  /// The campaign category this proposal belongs to.
  final CampaignCategory? category;

  /// The current document version being viewed.
  final DocumentVersion? currentVersion;

  /// The effective publish status of the proposal.
  final ProposalPublish effectivePublish;

  const ProposalMetadataSegmentData({
    required this.proposal,
    required this.category,
    required this.currentVersion,
    required this.effectivePublish,
  });

  /// Whether this is a draft proposal (not yet submitted).
  bool get isDraftProposal => proposal.metadata.id is DraftRef;

  /// Whether viewing the latest version of the proposal.
  bool get isLatestVersion => currentVersion?.isLatest ?? false;

  /// The document reference for this proposal.
  DocumentRef get proposalId => proposal.metadata.id;

  @override
  List<Object?> get props => [
    proposal,
    category,
    currentVersion,
    effectivePublish,
  ];
}
