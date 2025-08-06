import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(VotingRepository, () {
    late VotingRepository repository;
    late DocumentRef proposal1;
    late DocumentRef proposal2;
    late Vote draftVote1;
    late Vote draftVote2;
    late Vote draftVote1Updated;

    setUp(() {
      repository = VotingRepository();

      proposal1 = SignedDocumentRef.generateFirstRef();
      proposal2 = SignedDocumentRef.generateFirstRef();

      draftVote1 = Vote.draft(proposal: proposal1, type: VoteType.yes);
      draftVote2 = Vote.draft(proposal: proposal2, type: VoteType.abstain);
      draftVote1Updated = Vote.draft(proposal: proposal1, type: VoteType.abstain);
    });

    group('watchedCastedVotes', () {
      test('should provide current value to late subscribers', () async {
        await repository.castVotes([draftVote1]);

        final stream = repository.watchedCastedVotes;
        expect(stream.value, hasLength(1));
        expect(stream.value.first.proposal, equals(proposal1));
        expect(stream.value.first.type, equals(VoteType.yes));
        expect(stream.value.first.isCasted, isTrue);
      });
    });

    group('castVotes', () {
      test('should convert draft votes to casted votes', () async {
        await repository.castVotes([draftVote1]);

        final votes = repository.watchedCastedVotes.value;
        expect(votes, hasLength(1));
        expect(votes.first.proposal, equals(proposal1));
        expect(votes.first.type, equals(VoteType.yes));
        expect(votes.first.isCasted, isTrue);
      });

      test('should add multiple votes for different proposals', () async {
        await repository.castVotes([draftVote1, draftVote2]);

        final votes = repository.watchedCastedVotes.value;
        expect(votes, hasLength(2));

        final vote1 = votes.firstWhere((v) => v.proposal == proposal1);
        final vote2 = votes.firstWhere((v) => v.proposal == proposal2);

        expect(vote1.type, equals(VoteType.yes));
        expect(vote1.isCasted, isTrue);
        expect(vote2.type, equals(VoteType.abstain));
        expect(vote2.isCasted, isTrue);
      });

      test('should replace existing vote for same proposal', () async {
        await repository.castVotes([draftVote1]);
        expect(repository.watchedCastedVotes.value, hasLength(1));
        expect(repository.watchedCastedVotes.value.first.type, equals(VoteType.yes));

        await repository.castVotes([draftVote1Updated]);

        final votes = repository.watchedCastedVotes.value;
        expect(votes, hasLength(1));
        expect(votes.first.proposal, equals(proposal1));
        expect(votes.first.type, equals(VoteType.abstain));
        expect(votes.first.isCasted, isTrue);
      });

      test('should handle mixed new and updated votes', () async {
        await repository.castVotes([draftVote1]);
        expect(repository.watchedCastedVotes.value, hasLength(1));

        await repository.castVotes([draftVote1Updated, draftVote2]);

        final votes = repository.watchedCastedVotes.value;
        expect(votes, hasLength(2));

        final vote1 = votes.firstWhere((v) => v.proposal == proposal1);
        final vote2 = votes.firstWhere((v) => v.proposal == proposal2);

        expect(vote1.type, equals(VoteType.abstain));
        expect(vote2.type, equals(VoteType.abstain));
        expect(vote1.isCasted, isTrue);
        expect(vote2.isCasted, isTrue);
      });

      test('should emit updated list to stream subscribers', () async {
        final streamEvents = <List<Vote>>[];
        final subscription = repository.watchedCastedVotes.listen(streamEvents.add);

        await expectLater(
          repository.watchedCastedVotes.take(1),
          emits(isEmpty),
        );

        await repository.castVotes([draftVote1]);
        expect(streamEvents, hasLength(2));
        expect(streamEvents.last, hasLength(1));
        expect(streamEvents.last.first.proposal, equals(proposal1));

        await repository.castVotes([draftVote2]);
        expect(streamEvents, hasLength(3));
        expect(streamEvents.last, hasLength(2));

        await subscription.cancel();
      });

      test('should handle empty vote list', () async {
        await repository.castVotes([]);

        final votes = repository.watchedCastedVotes.value;
        expect(votes, isEmpty);
      });

      test('should maintain vote order consistency', () async {
        await repository.castVotes([draftVote1, draftVote2]);

        await repository.castVotes([draftVote1Updated]);

        final votes2 = repository.watchedCastedVotes.value;
        expect(votes2, hasLength(2));

        final proposals = votes2.map((v) => v.proposal).toSet();
        expect(proposals, contains(proposal1));
        expect(proposals, contains(proposal2));
      });
    });

    group('integration tests', () {
      test('should handle rapid successive castVotes calls', () async {
        final futures = <Future<void>>[];

        for (var i = 0; i < 5; i++) {
          final proposal = SignedDocumentRef.generateFirstRef();
          final vote = Vote.draft(proposal: proposal, type: VoteType.yes);
          futures.add(repository.castVotes([vote]));
        }

        await Future.wait(futures);

        final votes = repository.watchedCastedVotes.value;
        expect(votes, hasLength(5));
        expect(votes.every((v) => v.isCasted), isTrue);
      });
    });
  });
}
