import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [WorkspaceBloc].
final class WorkspaceBlocCache extends Equatable {
  final Campaign? campaign;
  final List<UsersProposalOverview>? proposals;

  const WorkspaceBlocCache({
    this.campaign,
    this.proposals,
  });

  @override
  List<Object?> get props => [
    campaign,
    proposals,
  ];

  WorkspaceBlocCache copyWith({
    Optional<Campaign>? campaign,
    Optional<List<UsersProposalOverview>>? proposals,
  }) {
    return WorkspaceBlocCache(
      campaign: campaign.dataOr(this.campaign),
      proposals: proposals.dataOr(this.proposals),
    );
  }
}
