import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class ProposalBuilderEvent extends Equatable {
  const ProposalBuilderEvent();
}

final class StartNewProposalEvent extends ProposalBuilderEvent {
  const StartNewProposalEvent();

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

final class ActiveNodeChangedEvent extends ProposalBuilderEvent {
  final NodeId? id;

  const ActiveNodeChangedEvent(this.id);

  @override
  List<Object?> get props => [id];
}
