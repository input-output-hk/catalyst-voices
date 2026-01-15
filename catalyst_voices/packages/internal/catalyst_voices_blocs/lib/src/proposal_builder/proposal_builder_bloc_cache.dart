import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderBlocCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentBuilder? proposalBuilder;
  final Document? proposalDocument;
  final ProposalBuilderMetadata? proposalMetadata;
  final CampaignCategory? category;
  final CampaignCategoryTotalAsk? categoryTotalAsk;
  final CommentTemplate? commentTemplate;
  final List<CommentWithReplies>? comments;
  final AccountPublicStatus? accountPublicStatus;
  final bool? isMaxProposalsLimitReached;

  const ProposalBuilderBlocCache({
    this.activeAccountId,
    this.proposalBuilder,
    this.proposalDocument,
    this.proposalMetadata,
    this.category,
    this.categoryTotalAsk,
    this.commentTemplate,
    this.comments,
    this.accountPublicStatus,
    this.isMaxProposalsLimitReached,
  });

  bool get isEmailVerified => accountPublicStatus?.isVerified ?? false;

  @override
  List<Object?> get props => [
    activeAccountId,
    proposalBuilder,
    proposalDocument,
    proposalMetadata,
    category,
    categoryTotalAsk,
    commentTemplate,
    comments,
    accountPublicStatus,
    isMaxProposalsLimitReached,
  ];

  ProposalBuilderBlocCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentBuilder>? proposalBuilder,
    Optional<Document>? proposalDocument,
    Optional<ProposalBuilderMetadata>? proposalMetadata,
    Optional<CampaignCategory>? category,
    Optional<CampaignCategoryTotalAsk>? categoryTotalAsk,
    Optional<CommentTemplate>? commentTemplate,
    Optional<List<CommentWithReplies>>? comments,
    Optional<AccountPublicStatus>? accountPublicStatus,
    Optional<bool>? isMaxProposalsLimitReached,
  }) {
    return ProposalBuilderBlocCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      proposalBuilder: proposalBuilder.dataOr(this.proposalBuilder),
      proposalDocument: proposalDocument.dataOr(this.proposalDocument),
      proposalMetadata: proposalMetadata.dataOr(this.proposalMetadata),
      category: category.dataOr(this.category),
      categoryTotalAsk: categoryTotalAsk.dataOr(this.categoryTotalAsk),
      commentTemplate: commentTemplate.dataOr(this.commentTemplate),
      comments: comments.dataOr(this.comments),
      accountPublicStatus: accountPublicStatus.dataOr(this.accountPublicStatus),
      isMaxProposalsLimitReached: isMaxProposalsLimitReached.dataOr(
        this.isMaxProposalsLimitReached,
      ),
    );
  }
}
