import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/voting/voting_mock_service.dart';
import 'package:catalyst_voices_services/src/voting/voting_service_impl.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class VotingService {
  factory VotingService(
    VotingRepository votingRepository,
    CampaignRepository campaignRepository,
    UserObserver userObserver,
    ActiveCampaignObserver campaignObserver,
  ) = VotingServiceImpl;

  factory VotingService.mock(
    VotingRepository votingRepository,
    ProposalService proposalService,
    CampaignService campaignService,
    UserObserver userObserver,
    ActiveCampaignObserver campaignObserver,
  ) = VotingMockService;

  Future<void> castVotes(List<Vote> draftVotes);

  /// Calculates voting role for active unlocked account and active campaign.
  ///
  /// This method is similar to [watchActiveVotingRole] but throws exception when
  /// can not calculate [AccountVotingRole].
  Future<AccountVotingRole> getActiveVotingRole();

  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef);

  Future<VoteProposal> getVoteProposal(DocumentRef proposalRef);

  /// Emits [AccountVotingRole] updates when related documents changing or voting power
  /// is updated for [accountId] and [campaignId].
  Stream<AccountVotingRole> watchAccountVotingRoleFor({
    required CatalystId accountId,
    required DocumentRef campaignId,
  });

  /// Helper method for [watchAccountVotingRoleFor] which reacts to [AccountVotingRole]
  /// for active account and active campaign.
  ///
  /// - Emits null if no active [Account] found or is locked.
  /// - Emits null if no active [Campaign] found.
  Stream<AccountVotingRole?> watchActiveVotingRole();

  Stream<List<Vote>> watchedCastedVotes();
}
