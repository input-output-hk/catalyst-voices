import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [WorkspaceBloc].
final class WorkspaceBlocCache extends Equatable {
  final Campaign? campaign;
  final List<UsersProposalOverview>? proposals;
  // TODO(LynxLynxx): Update to proper View model
  final List<Object>? invites;
  final CatalystId? activeAccountId;

  const WorkspaceBlocCache({
    this.campaign,
    this.proposals,
    this.invites,
    this.activeAccountId,
  });

  int get invitesCount => invites?.length ?? 0;

  int get proposalsCount => proposals?.length ?? 0;

  @override
  List<Object?> get props => [
    campaign,
    proposals,
    invites,
    activeAccountId,
  ];

  WorkspaceBlocCache copyWith({
    Optional<Campaign>? campaign,
    Optional<List<UsersProposalOverview>>? proposals,
    Optional<List<Object>>? invites,
    Optional<CatalystId>? activeAccountId,
  }) {
    return WorkspaceBlocCache(
      campaign: campaign.dataOr(this.campaign),
      proposals: proposals.dataOr(this.proposals),
      invites: invites.dataOr(this.invites),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
    );
  }
}
