import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/user/user_stream_transformers.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:rxdart/rxdart.dart';

final class VotingServiceImpl implements VotingService {
  final VotingRepository _votingRepository;
  final CampaignRepository _campaignRepository;
  final UserObserver _userObserver;
  final ActiveCampaignObserver _campaignObserver;

  VotingServiceImpl(
    this._votingRepository,
    this._campaignRepository,
    this._userObserver,
    this._campaignObserver,
  );

  @override
  Future<void> castVotes(List<Vote> draftVotes) {
    throw UnimplementedError();
  }

  @override
  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef) {
    throw UnimplementedError();
  }

  @override
  Future<VoteProposal> getVoteProposal(DocumentRef proposalRef) {
    throw UnimplementedError();
  }

  @override
  Stream<AccountVotingRole> watchAccountVotingRoleFor({
    required CatalystId accountId,
    required DocumentRef campaignId,
  }) {
    final campaignStream = Stream.fromFuture(_campaignRepository.getCampaign(id: campaignId.id));

    return campaignStream.switchMap((campaign) {
      return _votingRepository.watchAccountVotingRoleFor(
        accountId: accountId,
        campaign: campaign,
      );
    });
  }

  @override
  Stream<AccountVotingRole?> watchActiveVotingRole() {
    final accountStream = _userObserver.watchUser.toUnlockedActiveAccount
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
    throw UnimplementedError();
  }
}
