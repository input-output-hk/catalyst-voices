import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

// TODO(damian-molinski): Remove this and depend only on VotingRepository.
abstract interface class CastedVotesObserver {
  List<Vote> get votes;

  set votes(List<Vote> value);

  Stream<List<Vote>> get watchCastedVotes;

  Future<void> dispose();
}

final class CastedVotesObserverImpl implements CastedVotesObserver {
  final _votes = <Vote>[];
  final _votesSC = StreamController<List<Vote>>.broadcast();

  CastedVotesObserverImpl();

  @override
  List<Vote> get votes => _votes;

  @override
  set votes(List<Vote> value) {
    _votes
      ..clear()
      ..addAll(value);
    _votesSC.add(_votes);
  }

  @override
  Stream<List<Vote>> get watchCastedVotes async* {
    yield _votes;
    yield* _votesSC.stream;
  }

  @override
  Future<void> dispose() async {
    await _votesSC.close();
    return Future.value();
  }
}
