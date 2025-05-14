import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ActiveNodeChangedEvent extends ProposalBuilderEvent {
  final NodeId? id;

  const ActiveNodeChangedEvent(this.id);

  @override
  List<Object?> get props => [id];
}

final class DeleteProposalEvent extends ProposalBuilderEvent {
  const DeleteProposalEvent();

  @override
  List<Object?> get props => [];
}

final class ExportProposalEvent extends ProposalBuilderEvent {
  /// The prefix for the file where the proposal will be exported.
  final String filePrefix;

  const ExportProposalEvent({required this.filePrefix});

  @override
  List<Object?> get props => [filePrefix];
}

final class LoadDefaultProposalCategoryEvent extends ProposalBuilderEvent {
  const LoadDefaultProposalCategoryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProposalCategoryEvent extends ProposalBuilderEvent {
  final SignedDocumentRef categoryId;

  const LoadProposalCategoryEvent({
    required this.categoryId,
  });

  @override
  List<Object?> get props => [categoryId];
}

final class LoadProposalEvent extends ProposalBuilderEvent {
  final DocumentRef proposalId;

  const LoadProposalEvent({
    required this.proposalId,
  });

  @override
  List<Object?> get props => [proposalId];
}

final class MaxProposalsLimitChangedEvent extends ProposalBuilderEvent {
  final bool isLimitReached;

  const MaxProposalsLimitChangedEvent({required this.isLimitReached});

  @override
  List<Object?> get props => [isLimitReached];
}

final class MaxProposalsLimitReachedEvent extends ProposalBuilderEvent {
  const MaxProposalsLimitReachedEvent();

  @override
  List<Object?> get props => [];
}

sealed class ProposalBuilderEvent extends Equatable {
  const ProposalBuilderEvent();
}

final class ProposalSubmissionCloseDateEvent extends ProposalBuilderEvent {
  const ProposalSubmissionCloseDateEvent();

  @override
  List<Object?> get props => [];
}

final class PublishProposalEvent extends ProposalBuilderEvent {
  const PublishProposalEvent();

  @override
  List<Object?> get props => [];
}

final class RebuildActiveAccountProposalEvent extends ProposalBuilderEvent {
  final Account? account;

  const RebuildActiveAccountProposalEvent({required this.account});

  @override
  List<Object?> get props => [account];
}

final class RebuildCommentsProposalEvent extends ProposalBuilderEvent {
  final List<CommentWithReplies> comments;

  const RebuildCommentsProposalEvent({required this.comments});

  @override
  List<Object?> get props => [comments];
}

final class SectionChangedEvent extends ProposalBuilderEvent {
  final List<DocumentChange> changes;

  const SectionChangedEvent({
    required this.changes,
  });

  @override
  List<Object?> get props => [changes];
}

final class SubmitCommentEvent extends ProposalBuilderEvent {
  final Document document;
  final SignedDocumentRef? reply;

  const SubmitCommentEvent({
    required this.document,
    required this.reply,
  });

  @override
  List<Object?> get props => [document, reply];
}

final class SubmitProposalEvent extends ProposalBuilderEvent {
  const SubmitProposalEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateCommentBuilderEvent extends ProposalBuilderEvent {
  final SignedDocumentRef ref;
  final bool show;

  const UpdateCommentBuilderEvent({
    required this.ref,
    required this.show,
  });

  @override
  List<Object?> get props => [ref, show];
}

final class UpdateCommentRepliesEvent extends ProposalBuilderEvent {
  final SignedDocumentRef ref;
  final bool show;

  const UpdateCommentRepliesEvent({
    required this.ref,
    required this.show,
  });

  @override
  List<Object?> get props => [ref, show];
}

final class UpdateCommentsSortEvent extends ProposalBuilderEvent {
  final ProposalCommentsSort sort;

  const UpdateCommentsSortEvent({required this.sort});

  @override
  List<Object?> get props => [sort];
}

final class UpdateUsernameEvent extends ProposalBuilderEvent {
  final String value;

  const UpdateUsernameEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class ValidateProposalEvent extends ProposalBuilderEvent {
  const ValidateProposalEvent();

  @override
  List<Object?> get props => [];
}
