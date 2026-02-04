import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [ProposalCubit].
final class ProposalCubitCache extends Equatable {
  final DocumentRef? id;
  final CatalystId? activeAccountId;
  final ProposalDataV2? proposalData;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;

  const ProposalCubitCache({
    this.id,
    this.activeAccountId,
    this.proposalData,
    this.commentTemplate,
    this.comments,
  });

  @override
  List<Object?> get props => [
    id,
    activeAccountId,
    proposalData,
    commentTemplate,
    comments,
  ];

  ProposalCubitCache copyWith({
    Optional<DocumentRef>? id,
    Optional<CatalystId>? activeAccountId,
    Optional<ProposalDataV2>? proposalData,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
  }) {
    return ProposalCubitCache(
      id: id.dataOr(this.id),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      proposalData: proposalData.dataOr(this.proposalData),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
    );
  }

  ProposalCubitCache copyWithIsFavorite({required bool value}) {
    return copyWith(proposalData: Optional(proposalData?.copyWith(isFavorite: value)));
  }

  ProposalCubitCache copyWithoutProposal() {
    return copyWith(
      id: const Optional.empty(),
      proposalData: const Optional.empty(),
      commentTemplate: const Optional.empty(),
      comments: const Optional.empty(),
    );
  }
}
