import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

sealed class ProposalBuilderEvent extends Equatable {
  const ProposalBuilderEvent();
}

final class LoadProposalEvent extends ProposalBuilderEvent {
  final String id;

  const LoadProposalEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

final class UpdateStepAnswerEvent extends ProposalBuilderEvent {
  final SectionStepId id;
  final MarkdownData? data;

  const UpdateStepAnswerEvent({
    required this.id,
    this.data,
  });

  @override
  List<Object?> get props => [id, data];
}

final class ActiveStepChangedEvent extends ProposalBuilderEvent {
  final SectionStepId? id;

  const ActiveStepChangedEvent(this.id);

  @override
  List<Object?> get props => [id];
}
