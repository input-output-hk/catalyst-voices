import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class ProposalBuilderEvent extends Equatable {
  const ProposalBuilderEvent();
}

final class LoadDefaultProposalTemplateEvent extends ProposalBuilderEvent {
  const LoadDefaultProposalTemplateEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProposalTemplateEvent extends ProposalBuilderEvent {
  final String id;

  const LoadProposalTemplateEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

final class LoadProposalEvent extends ProposalBuilderEvent {
  final String id;

  const LoadProposalEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

final class ActiveNodeChangedEvent extends ProposalBuilderEvent {
  final NodeId? id;

  const ActiveNodeChangedEvent(this.id);

  @override
  List<Object?> get props => [id];
}
