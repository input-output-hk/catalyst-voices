import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ChangeVersionEvent extends ProposalEvent {
  final String version;

  const ChangeVersionEvent({
    required this.version,
  });

  @override
  List<Object?> get props => [version];
}

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

final class UpdateProposalFavoriteEvent extends ProposalEvent {
  final bool isFavorite;

  const UpdateProposalFavoriteEvent({
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [isFavorite];
}
