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
  const ExportProposalEvent();

  @override
  List<Object?> get props => [];
}

final class LoadDefaultProposalTemplateEvent extends ProposalBuilderEvent {
  const LoadDefaultProposalTemplateEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProposalEvent extends ProposalBuilderEvent {
  final String id;

  const LoadProposalEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

final class LoadProposalTemplateEvent extends ProposalBuilderEvent {
  final String id;

  const LoadProposalTemplateEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

sealed class ProposalBuilderEvent extends Equatable {
  const ProposalBuilderEvent();
}

final class PublishProposalEvent extends ProposalBuilderEvent {
  const PublishProposalEvent();

  @override
  List<Object?> get props => [];
}

final class SectionChangedEvent extends ProposalBuilderEvent {
  final List<DocumentChange> changes;

  const SectionChangedEvent({
    required this.changes,
  });

  @override
  List<Object?> get props => [changes];
}

final class ShareProposalEvent extends ProposalBuilderEvent {
  const ShareProposalEvent();

  @override
  List<Object?> get props => [];
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
