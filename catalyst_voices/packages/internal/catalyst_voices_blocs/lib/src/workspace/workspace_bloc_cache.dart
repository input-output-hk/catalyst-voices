// import 'package:catalyst_voices_models/catalyst_voices_models.dart';
// import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
// import 'package:equatable/equatable.dart';

// /// Cache for [WorkspaceBloc].
// final class WorkspaceBlocCache extends Equatable {
//   final Campaign? campaign;
//   final List<UsersProposalOverview>? proposals;
//   // TODO(LynxLynxx): Update to proper View model
//   final List<Object>? invites;
//   final CatalystId? activeAccountId;
//   final int invitesCount;
//   final int proposalCount;

//   const WorkspaceBlocCache({
//     this.campaign,
//     this.proposals,
//     this.invites,
//     this.activeAccountId,
//     this.invitesCount = 0,
//     this.proposalCount = 0,
//   });

//   @override
//   List<Object?> get props => [
//     campaign,
//     proposals,
//     invites,
//     activeAccountId,
//     invitesCount,
//     proposalCount,
//   ];

//   WorkspaceBlocCache copyWith({
//     Optional<Campaign>? campaign,
//     Optional<List<UsersProposalOverview>>? proposals,
//     Optional<List<Object>>? invites,
//     Optional<CatalystId>? activeAccountId,
//     int? invitesCount,
//     int? proposalCount,
//   }) {
//     return WorkspaceBlocCache(
//       campaign: campaign.dataOr(this.campaign),
//       proposals: proposals.dataOr(this.proposals),
//       invites: invites.dataOr(this.invites),
//       activeAccountId: activeAccountId.dataOr(this.activeAccountId),
//       invitesCount: invitesCount ?? this.invitesCount,
//       proposalCount: proposalCount ?? this.proposalCount,
//     );
//   }
// }
