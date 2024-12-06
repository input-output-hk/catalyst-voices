import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}

final class LoadCurrentProposalEvent extends WorkspaceEvent {
  const LoadCurrentProposalEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateStepAnswerEvent extends WorkspaceEvent {
  final SectionStepId id;
  final MarkdownData? data;

  const UpdateStepAnswerEvent({
    required this.id,
    this.data,
  });

  @override
  List<Object?> get props => [id, data];
}

final class ActiveStepChangedEvent extends WorkspaceEvent {
  final SectionStepId? id;

  const ActiveStepChangedEvent(this.id);

  @override
  List<Object?> get props => [id];
}
