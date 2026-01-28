import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/voting/casted_votes_observer.dart';
import 'package:catalyst_voices_repositories/src/voting/voting_mock_repository.dart';

abstract interface class VotingRepository implements CastedVotesObserver {
  factory VotingRepository(CastedVotesObserver votesObserver) = VotingMockRepository;

  Future<void> castVotes(List<Vote> draftVotes);

  /// Similar to [watchAccountVotingRoleFor] but calculates [AccountVotingRole] one time.
  Future<AccountVotingRole> getAccountVotingRoleFor({
    required CatalystId accountId,
    required Campaign campaign,
  });

  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef);

  /// Emits update to date [AccountVotingRole] for given [accountId] in context of [campaign].
  Stream<AccountVotingRole> watchAccountVotingRoleFor({
    required CatalystId accountId,
    required Campaign campaign,
  });
}
