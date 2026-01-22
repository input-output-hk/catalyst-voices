import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class VotingRepositoryImpl implements VotingRepository {
  @override
  List<Vote> get votes => throw UnimplementedError('CastedVotesObserver have to removed');

  @override
  set votes(List<Vote> value) => throw UnimplementedError('CastedVotesObserver have to removed');

  @override
  Stream<List<Vote>> get watchCastedVotes {
    throw UnimplementedError('CastedVotesObserver have to removed');
  }

  @override
  Future<void> castVotes(List<Vote> draftVotes) {
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() => throw UnimplementedError('CastedVotesObserver have to removed');

  @override
  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef) {
    throw UnimplementedError();
  }

  // TODO(damian-molinski): implement local storage for AccountVotingRole
  // TODO(damian-molinski): watch local storage for AccountVotingRole
  // TODO(damian-molinski): validate voting role campaign id and timeline's snapshot deadline.
  // TODO(damian-molinski): react to synchronisation of voting power (Snapshot).
  @override
  Stream<AccountVotingRole> watchAccountVotingRoleFor({
    required CatalystId accountId,
    required Campaign campaign,
  }) {
    final individual = AccountVotingRoleIndividual(
      accountId: accountId,
      campaignId: campaign.id,
      votingPower: Snapshot.done(data: VotingPower.dummy()),
    );

    return Stream.value(individual);
  }
}
