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
      repository = VotingRepository(CastedVotesObserverImpl());

      proposal1 = SignedDocumentRef.generateFirstRef();
      proposal2 = SignedDocumentRef.generateFirstRef();

      draftVote1 = Vote.draft(proposal: proposal1, type: VoteType.yes);
      draftVote2 = Vote.draft(proposal: proposal2, type: VoteType.abstain);
      draftVote1Updated = Vote.draft(proposal: proposal1, type: VoteType.abstain);
    });

    group('watchedCastedVotes', () {
      test('should provide current value to late subscribers', () async {
        //Arrange
        await repository.castVotes([draftVote1]);

        //Act
        final votesStream = repository.watchedCastedVotes;

        //Assert
        final casted = draftVote1.toCasted();
        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted],
          ]),
        );
      });
    });

    group('castVotes', () {
      test('should convert draft votes to casted votes', () async {
        final votesStream = repository.watchedCastedVotes;
        final casted = draftVote1.toCasted();

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted],
          ]),
        );

        await repository.castVotes([draftVote1]);

        final votes = await repository.watchedCastedVotes.first;
        expect(votes, hasLength(1));
        expect(votes.first.proposal, equals(proposal1));
        expect(votes.first.type, equals(VoteType.yes));
        expect(votes.first.isCasted, isTrue);
        expect(votes.first.id, isA<SignedDocumentRef>());
      });

      test('should add multiple votes for different proposals', () async {
        final votesStream = repository.watchedCastedVotes;
        final casted1 = draftVote1.toCasted();
        final casted2 = draftVote2.toCasted();

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted1, casted2],
          ]),
        );

        await repository.castVotes([draftVote1, draftVote2]);
      });

      test('should replace existing vote for same proposal', () async {
        final votesStream = repository.watchedCastedVotes;
        final casted1 = draftVote1.toCasted();
        final casted1Updated = draftVote1Updated.toCasted();

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted1],
            <Vote>[casted1Updated],
          ]),
        );

        await repository.castVotes([draftVote1]);
        await Future<void>.delayed(const Duration(milliseconds: 1)); // Small delay
        await repository.castVotes([draftVote1Updated]);
      });

      test('should handle mixed new and updated votes', () async {
        final votesStream = repository.watchedCastedVotes;
        final casted1 = draftVote1.toCasted();
        final casted1Updated = draftVote1Updated.toCasted();
        final casted2 = draftVote2.toCasted();

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted1],
            <Vote>[casted1Updated, casted2],
          ]),
        );

        await repository.castVotes([draftVote1]);
        await Future<void>.delayed(const Duration(milliseconds: 1)); // Small delay
        await repository.castVotes([draftVote1Updated, draftVote2]);
      });

      test('should emit updated list to stream subscribers', () async {
        final votesStream = repository.watchedCastedVotes;
        final casted = draftVote1.toCasted();

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted],
          ]),
        );

        await repository.castVotes([draftVote1]);
      });

      test('should handle empty vote list', () async {
        final votesStream = repository.watchedCastedVotes;

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[],
          ]),
        );

        await repository.castVotes([]);
      });

      test('should maintain vote order consistency', () async {
        final votesStream = repository.watchedCastedVotes;
        final casted1 = draftVote1.toCasted();
        final casted2 = draftVote2.toCasted();
        final casted1Updated = draftVote1Updated.toCasted();

        expect(
          votesStream,
          emitsInOrder(<List<Vote>>[
            <Vote>[casted1, casted2], // After casting both votes
            <Vote>[casted1Updated, casted2], // After updating first vote
          ]),
        );

        await repository.castVotes([draftVote1, draftVote2]);
        await Future<void>.delayed(const Duration(milliseconds: 1)); // Small delay
        await repository.castVotes([draftVote1Updated]);
      });
    });
  });
}
