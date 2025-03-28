import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

sealed class ProposalBuilderEvent extends Equatable {
  const ProposalBuilderEvent();
}

final class PublishProposalEvent extends ProposalBuilderEvent {
  const PublishProposalEvent();

  @override
  List<Object?> get props => [];
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

final class SubmitProposalEvent extends ProposalBuilderEvent {
  const SubmitProposalEvent();

  @override
  List<Object?> get props => [];
}

final class ValidateProposalEvent extends ProposalBuilderEvent {
  const ValidateProposalEvent();

  @override
  List<Object?> get props => [];
}
