import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:rxdart/rxdart.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;

  const VotingMockService(this._votingRepository);

  @override
  Future<void> castVotes(List<Vote> draftVotes) async {
    await _votingRepository.castVotes(draftVotes);
  }

  @override
  ValueStream<List<Vote>> watchedCastedVotes() {
    return _votingRepository.watchedCastedVotes;
  }
}

abstract interface class VotingService {
  const factory VotingService(
    VotingRepository votingRepository,
  ) = VotingMockService;

  Future<void> castVotes(List<Vote> draftVotes);

  ValueStream<List<Vote>> watchedCastedVotes();
}
