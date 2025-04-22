import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderBlocCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentBuilder? proposalBuilder;
  final Document? proposalDocument;
  final ProposalBuilderMetadata? proposalMetadata;
  final CampaignCategory? category;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;
  final AccountEmailVerificationStatus? emailStatus;

  const ProposalBuilderBlocCache({
    this.activeAccountId,
    this.proposalBuilder,
    this.proposalDocument,
    this.proposalMetadata,
    this.category,
    this.commentTemplate,
    this.comments,
    this.emailStatus,
  });

  @override
  List<Object?> get props => [
        activeAccountId,
        proposalBuilder,
        proposalDocument,
        proposalMetadata,
        category,
        commentTemplate,
        comments,
        emailStatus,
      ];

  ProposalBuilderBlocCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentBuilder>? proposalBuilder,
    Optional<Document>? proposalDocument,
    Optional<ProposalBuilderMetadata>? proposalMetadata,
    Optional<CampaignCategory>? category,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
    Optional<AccountEmailVerificationStatus>? emailStatus,
  }) {
    return ProposalBuilderBlocCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      proposalBuilder: proposalBuilder.dataOr(this.proposalBuilder),
      proposalDocument: proposalDocument.dataOr(this.proposalDocument),
      proposalMetadata: proposalMetadata.dataOr(this.proposalMetadata),
      category: category.dataOr(this.category),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
      emailStatus: emailStatus.dataOr(this.emailStatus),
    );
  }
}
