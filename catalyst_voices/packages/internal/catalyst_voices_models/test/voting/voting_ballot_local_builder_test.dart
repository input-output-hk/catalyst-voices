import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(VotingBallotLocalBuilder, () {
    test('voting on same ref updates exiting vote', () {
      // Given
      final builder = VotingBallotLocalBuilder();

      final proposalRef = SignedDocumentRef.generateFirstRef();

      // When
      builder
        ..voteOn(proposal: proposalRef, type: VoteType.yes)
        ..voteOn(proposal: proposalRef, type: VoteType.abstain);

      // Then
      expect(builder.length, 1);

      final votes = builder.votes;

      expect(votes[0].proposal, proposalRef);
      expect(votes[0].type, VoteType.abstain);
    });

    test('removing vote on ref works as expected', () {
      // Given
      final builder = VotingBallotLocalBuilder();

      final refOne = SignedDocumentRef.generateFirstRef();
      final refTwo = SignedDocumentRef.generateFirstRef();

      // When
      final voteOne = builder.voteOn(proposal: refOne, type: VoteType.yes);
      final voteTwo = builder.voteOn(proposal: refTwo, type: VoteType.abstain);

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
      final builder = VotingBallotLocalBuilder();

      final ref = SignedDocumentRef.generateFirstRef();

      // When
      builder
        ..voteOn(proposal: ref, type: VoteType.abstain)
        ..voteOn(proposal: ref, type: VoteType.yes);

      // Then
      final vote = builder.getVoteOn(ref);

      expect(vote, isNotNull);
      expect(vote!.type, VoteType.yes);
      expect(vote.proposal, ref);
    });

    test('votes is not modifiable', () {
      // Given
      final builder = VotingBallotLocalBuilder();

      final refs = [
        SignedDocumentRef.generateFirstRef(),
        SignedDocumentRef.generateFirstRef(),
      ];

      // When
      for (final ref in refs) {
        builder.voteOn(proposal: ref, type: VoteType.yes);
      }

      // Then
      final votes = builder.votes;

      void removeVote() {
        votes.removeLast();
      }

      expect(removeVote, throwsA(isA<UnsupportedError>()));
    });

    test('throws error when adding second version of same vote', () {
      // Given
      final builder = VotingBallotLocalBuilder();
      final proposal = SignedDocumentRef.generateFirstRef();

      // When
      final firstVote = Vote.draft(proposal: proposal, type: VoteType.abstain);
      final secondVote = Vote(
        id: firstVote.id.nextVersion(),
        proposal: proposal,
        type: VoteType.yes,
      );

      // Then
      builder.addVote(firstVote);

      void addingSecondVote() {
        builder.addVote(secondVote);
      }

      expect(addingSecondVote, throwsA(isA<AssertionError>()));
    });
  });
}
