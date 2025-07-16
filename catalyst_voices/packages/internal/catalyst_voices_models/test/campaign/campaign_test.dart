import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(CampaignPhaseStatus, () {
    late DateTime now;

    setUp(() {
      now = DateTime.now();
    });

    test('fromRange returns upcoming status when current date is before the range', () {
      // Arrange
      final now = DateTime.now();

      final range = DateRange(
        from: now.plusDays(2),
        to: now.plusDays(1),
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range);

      // Assert
      expect(result, equals(CampaignPhaseStatus.upcoming));
    });

    test('fromRange returns active status when current date is in the range', () {
      // Arrange
      final range = DateRange(
        from: now.minusDays(2),
        to: now.plusDays(2),
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range);

      // Assert
      expect(result, equals(CampaignPhaseStatus.active));
    });

    test('fromRange returns post status when current date is after the range', () {
      // Arrange
      final range = DateRange(
        from: now.minusDays(2),
        to: now.minusDays(1),
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range);

      // Assert
      expect(result, equals(CampaignPhaseStatus.post));
    });

    test('fromRange handles range with null from date', () {
      // Arrange
      final range = DateRange(
        from: null,
        to: now.plusDays(2),
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range);

      // Assert
      expect(result, equals(CampaignPhaseStatus.active));
    });

    test('fromRange handles range with null to date', () {
      // Arrange
      final range = DateRange(
        from: now.minusDays(2),
        to: null,
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range);

      // Assert
      expect(result, equals(CampaignPhaseStatus.active));
    });

    test('fromRange handles range with both null dates', () {
      // Arrange
      const range = DateRange(
        from: null,
        to: null,
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range);

      // Assert
      expect(result, equals(CampaignPhaseStatus.active));
    });
  });

  group(Campaign, () {
    late DateTime now;

    setUp(() {
      now = DateTime.now();
    });

    test('state returns correct state for single active phase', () {
      // Arrange
      final campaign = Campaign(
        selfRef: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: const Coin(100),
        fundNumber: 1,
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              stage: CampaignPhaseStage.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
          ],
        ),
        publish: CampaignPublish.published,
      );

      // Act
      final result = campaign.state;

      // Assert
      expect(
        result.any((state) => state.phase.stage == CampaignPhaseStage.proposalSubmission),
        isTrue,
      );

      expect(
        result
            .firstWhereOrNull((state) => state.phase.stage == CampaignPhaseStage.proposalSubmission)
            ?.status,
        equals(CampaignPhaseStatus.active),
      );
    });

    test('state returns correct state for multiple phases', () {
      // Arrange
      final campaign = Campaign(
        selfRef: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: const Coin(100),
        fundNumber: 1,
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              stage: CampaignPhaseStage.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.votingRegistration,
              timeline: DateRange(
                from: now.plusDays(1),
                to: now.plusDays(2),
              ),
            ),
          ],
        ),
        publish: CampaignPublish.published,
      );

      // Act
      final result = campaign.state;

      // Assert
      expect(
        result.length,
        equals(2),
      );

      expect(
        result
            .firstWhereOrNull((state) => state.phase.stage == CampaignPhaseStage.proposalSubmission)
            ?.status,
        equals(CampaignPhaseStatus.active),
      );

      expect(
        result
            .firstWhereOrNull((state) => state.phase.stage == CampaignPhaseStage.votingRegistration)
            ?.status,
        equals(CampaignPhaseStatus.active),
      );
    });
    test('state return closest phase when no active phase', () {
      // Arrange
      final campaign = Campaign(
        selfRef: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: const Coin(100),
        fundNumber: 1,
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              stage: CampaignPhaseStage.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(10),
                to: now.minusDays(9),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(8),
                to: now.minusDays(7),
              ),
            ),
            CampaignPhase(
              title: 'Reviewers and Moderators registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.reviewRegistration,
              timeline: DateRange(
                from: now.plusDays(1),
                to: now.plusDays(2),
              ),
            ),
          ],
        ),
        publish: CampaignPublish.published,
      );

      // Act
      final result = campaign.state;

      // Assert
      expect(result.length, equals(1));

      expect(
        result.first.phase.stage,
        equals(CampaignPhaseStage.reviewRegistration),
      );

      expect(
        result.first.status,
        equals(CampaignPhaseStatus.upcoming),
      );
    });

    test('state return closest phase that is post when there is no active phase', () {
      // Arrange
      final campaign = Campaign(
        selfRef: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: const Coin(100),
        fundNumber: 1,
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              stage: CampaignPhaseStage.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(10),
                to: now.minusDays(9),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(2),
                to: now.minusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Reviewers and Moderators registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.reviewRegistration,
              timeline: DateRange(
                from: now.plusDays(2),
                to: now.plusDays(3),
              ),
            ),
          ],
        ),
        publish: CampaignPublish.published,
      );

      // Act
      final result = campaign.state;

      // Assert
      expect(result.length, equals(1));

      expect(
        result.first.phase.stage,
        equals(CampaignPhaseStage.votingRegistration),
      );

      expect(
        result.first.status,
        equals(CampaignPhaseStatus.post),
      );
    });

    test('state to return correct state for single phase', () {
      // Arrange
      final campaign = Campaign(
        selfRef: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: const Coin(100),
        fundNumber: 1,
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              stage: CampaignPhaseStage.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(10),
                to: now.minusDays(9),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Reviewers and Moderators registration',
              description: 'Description 1',
              stage: CampaignPhaseStage.reviewRegistration,
              timeline: DateRange(
                from: now.plusDays(2),
                to: now.plusDays(3),
              ),
            ),
          ],
        ),
        publish: CampaignPublish.published,
      );

      // Act
      final resultProposalSubmission = campaign.stateTo(CampaignPhaseStage.proposalSubmission);
      final resultVotingRegistration = campaign.stateTo(CampaignPhaseStage.votingRegistration);
      final resultReviewRegistration = campaign.stateTo(CampaignPhaseStage.reviewRegistration);

      // Assert
      expect(resultProposalSubmission.phase.stage, equals(CampaignPhaseStage.proposalSubmission));
      expect(resultProposalSubmission.status, equals(CampaignPhaseStatus.post));

      expect(resultVotingRegistration.phase.stage, equals(CampaignPhaseStage.votingRegistration));
      expect(resultVotingRegistration.status, equals(CampaignPhaseStatus.active));

      expect(resultReviewRegistration.phase.stage, equals(CampaignPhaseStage.reviewRegistration));
      expect(resultReviewRegistration.status, equals(CampaignPhaseStatus.upcoming));
    });
  });
}
