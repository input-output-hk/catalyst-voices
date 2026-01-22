import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:collection/collection.dart';

final class VotingMockRepository implements VotingRepository {
  final CastedVotesObserver _votesObserver;

  VotingMockRepository(this._votesObserver) {
    unawaited(_loadCastedVotes());
  }

  @override
  List<Vote> get votes => _votesObserver.votes;

  @override
  set votes(List<Vote> value) => _votesObserver.votes = value;

  @override
  Stream<List<Vote>> get watchCastedVotes => _votesObserver.watchCastedVotes;

  @override
  Future<void> castVotes(List<Vote> draftVotes) async {
    final castedVotes = <Vote>[];

    for (final vote in draftVotes) {
      castedVotes.add(vote.toCasted());
    }

    // TODO(LynxLynxx): Save casted votes to storage or remote source

    // Create a map for efficient lookup and updates
    final votesMap = {for (final vote in votes) vote.proposal: vote};

    // Update or add new votes
    for (final newVote in castedVotes) {
      votesMap[newVote.proposal] = newVote;
    }
    votes = votesMap.values.toList();
  }

  @override
  Future<void> dispose() async {
    await _votesObserver.dispose();
  }

  @override
  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef) async {
    return _votesObserver.votes.firstWhereOrNull((vote) => vote.proposal == proposalRef);
  }

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

  Future<void> _loadCastedVotes() async {
    // TODO(LynxLynxx): Load casted votes from storage or remote source

    // Initialize with empty list if no votes are loaded
    votes = <Vote>[];
  }
}
