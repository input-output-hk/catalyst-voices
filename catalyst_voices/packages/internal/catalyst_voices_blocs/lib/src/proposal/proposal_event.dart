import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class ProposalEvent extends Equatable {
  const ProposalEvent();
}

final class ShowProposalEvent extends ProposalEvent {
  final DocumentRef ref;

  const ShowProposalEvent({
    required this.ref,
  });

  @override
  List<Object?> get props => [ref];
}
