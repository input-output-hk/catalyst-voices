import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(VotingBallotBuilder, () {
    test('voting on same ref updates exiting vote', () {
      // Given
      final builder = VotingBallotBuilder();

      final proposalRef = SignedDocumentRef.generateFirstRef();

      // When
      builder
        ..voteOn(ref: proposalRef, type: VoteType.yes)
        ..voteOn(ref: proposalRef, type: VoteType.abstain);

      // Then
      expect(builder.length, 1);

      final votes = builder.votes;

      expect(votes[0].ref, proposalRef);
      expect(votes[0].type, VoteType.abstain);
    });

    test('removing vote on ref works as expected', () {
      // Given
      final builder = VotingBallotBuilder();

      final refOne = SignedDocumentRef.generateFirstRef();
      final refTwo = SignedDocumentRef.generateFirstRef();

      // When
      final voteOne = builder.voteOn(ref: refOne, type: VoteType.yes);
      final voteTwo = builder.voteOn(ref: refTwo, type: VoteType.abstain);

      final votes = [voteOne, voteTwo];

      // Then
      expect(builder.length, 2);
      expect(builder.votes, equals(votes));

      builder.removeVoteOn(refOne);

      expect(builder.length, 1);
      expect(builder.votes[0], voteTwo);
    });

    test('getVoteOn returns latest vote on ref', () {
      // Given
      final builder = VotingBallotBuilder();

      final ref = SignedDocumentRef.generateFirstRef();

      // When
      builder
        ..voteOn(ref: ref, type: VoteType.abstain)
        ..voteOn(ref: ref, type: VoteType.yes);

      // Then
      final vote = builder.getVoteOn(ref);

      expect(vote, isNotNull);
      expect(vote!.type, VoteType.yes);
      expect(vote.ref, ref);
    });

    test('votes is not modifiable', () {
      // Given
      final builder = VotingBallotBuilder();

      final refs = [
        SignedDocumentRef.generateFirstRef(),
        SignedDocumentRef.generateFirstRef(),
      ];

      // When
      for (final ref in refs) {
        builder.voteOn(ref: ref, type: VoteType.yes);
      }

      // Then
      final votes = builder.votes;

      void removeVote() {
        votes.removeLast();
      }

      expect(removeVote, throwsA(isA<UnsupportedError>()));
    });
  });
}
