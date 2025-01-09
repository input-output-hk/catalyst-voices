import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

final class ActiveStepChangedEvent extends ProposalBuilderEvent {
  final NodeId? id;

  const ActiveStepChangedEvent(this.id);

  @override
  List<Object?> get props => [id];
}
