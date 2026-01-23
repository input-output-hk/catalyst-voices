import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/user/user_stream_transformers.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:rxdart/rxdart.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;
  final ProposalService _proposalService;
  final CampaignService _campaignService;
  final UserObserver _userObserver;
  final ActiveCampaignObserver _campaignObserver;

  VotingMockService(
    this._votingRepository,
    this._proposalService,
    this._campaignService,
    this._userObserver,
    this._campaignObserver,
  );

  @override
  Future<void> castVotes(List<Vote> draftVotes) async {
    await _votingRepository.castVotes(draftVotes);
  }

  @override
  Future<AccountVotingRole> getActiveVotingRole() async {
    final activeAccount = _userObserver.user.activeAccount;
    if (activeAccount == null) {
      throw const ActiveAccountNotFoundException();
    }
    if (!activeAccount.keychain.lastIsUnlocked) {
      throw AccountKeychainLockedException(activeAccount.catalystId);
    }

    final accountId = activeAccount.catalystId;
    final campaignId = _campaignObserver.campaign?.id;
    if (campaignId == null) {
      throw const ActiveCampaignNotFoundException();
    }

    return AccountVotingRoleIndividual(
      accountId: accountId,
      campaignId: campaignId,
      votingPower: Snapshot.done(data: VotingPower.dummy()),
    );
  }

  @override
  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef) {
    return _votingRepository.getProposalLastCastedVote(proposalRef);
  }

  @override
  Future<VoteProposal> getVoteProposal(DocumentRef proposalRef) async {
    final proposal = await _proposalService.getProposal(id: proposalRef);
    final lastCastedVote = await getProposalLastCastedVote(proposalRef);
    // TODO(dt-iohk): consider to use campaign assigned to the proposal
    final campaign = await _campaignService.getActiveCampaign();

    final category = campaign!.categories.firstWhere(
      (category) => proposal.parameters.contains(category.id),
      orElse: () => throw NotFoundException(message: 'Category not found in ${campaign.id}'),
    );

    return VoteProposal.fromData(
      proposal: proposal,
      category: category,
      lastCastedVote: lastCastedVote,
    );
  }

  @override
  Stream<AccountVotingRole> watchAccountVotingRoleFor({
    required CatalystId accountId,
    required DocumentRef campaignId,
  }) {
    final individual = AccountVotingRoleIndividual(
      accountId: accountId,
      campaignId: campaignId,
      votingPower: Snapshot.done(data: VotingPower.dummy()),
    );

    return Stream.value(individual);
  }

  @override
  Stream<AccountVotingRole?> watchActiveVotingRole() {
    final accountStream = _userObserver.watchUser
        .toUnlockedActiveAccount()
        .map((account) => account?.catalystId)
        .distinct((previous, next) => previous.isSameAs(next));

    final campaignStream = _campaignObserver.watchCampaign
        .map((campaign) => campaign?.id)
        .distinct();

    return Rx.combineLatest2(
      accountStream,
      campaignStream,
      (accountId, campaignId) => (accountId, campaignId),
    ).switchMap((value) {
      final accountId = value.$1;
      final campaignId = value.$2;
      if (accountId == null || campaignId == null) {
        return Stream.value(null);
      }

      return watchAccountVotingRoleFor(accountId: accountId, campaignId: campaignId);
    });
  }

  @override
  Stream<List<Vote>> watchedCastedVotes() {
    return _votingRepository.watchCastedVotes;
  }
}
