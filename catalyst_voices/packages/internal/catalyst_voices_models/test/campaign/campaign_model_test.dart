import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(CampaignPhaseStatus, () {
    late DateTime now;

    setUp(() {
      DateTimeExt.mockedDateTime = DateTime(2025, 7, 17);
      now = DateTimeExt.now();
    });

    test('fromRange returns upcoming status when current date is before the range', () {
      // Arrange
      final range = DateRange(
        from: now.plusDays(2),
        to: now.plusDays(1),
      );

      // Act
      final result = CampaignPhaseStatus.fromRange(range, now);

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
      final result = CampaignPhaseStatus.fromRange(range, now);

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
      final result = CampaignPhaseStatus.fromRange(range, now);

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
      final result = CampaignPhaseStatus.fromRange(range, now);

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
      final result = CampaignPhaseStatus.fromRange(range, now);

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
      final result = CampaignPhaseStatus.fromRange(range, now);

      // Assert
      expect(result, equals(CampaignPhaseStatus.active));
    });
  });

  group(Campaign, () {
    late DateTime now;

    setUp(() {
      now = DateTimeExt.now();
    });

    test('state returns correct state for single active phase', () {
      // Arrange
      final campaign = Campaign(
        id: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: _multiCurrency(100),
        fundNumber: 1,
        categories: const [],
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              type: CampaignPhaseType.proposalSubmission,
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
        result.activePhases.any(
          (state) => state.phase.type == CampaignPhaseType.proposalSubmission,
        ),
        isTrue,
      );

      expect(
        result.activePhases
            .firstWhereOrNull((state) => state.phase.type == CampaignPhaseType.proposalSubmission)
            ?.status,
        equals(CampaignPhaseStatus.active),
      );
    });

    test('state returns correct state for multiple phases', () {
      // Arrange
      final campaign = Campaign(
        id: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: _multiCurrency(100),
        fundNumber: 1,
        categories: const [],
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              type: CampaignPhaseType.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
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
        result.activePhases.length,
        equals(2),
      );

      expect(
        result.activePhases
            .firstWhereOrNull((state) => state.phase.type == CampaignPhaseType.proposalSubmission)
            ?.status,
        equals(CampaignPhaseStatus.active),
      );

      expect(
        result.activePhases
            .firstWhereOrNull((state) => state.phase.type == CampaignPhaseType.votingRegistration)
            ?.status,
        equals(CampaignPhaseStatus.active),
      );
    });

    test('state return closest phase when no active phase', () {
      // Arrange
      final campaign = Campaign(
        id: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: _multiCurrency(100),
        fundNumber: 1,
        categories: const [],
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              type: CampaignPhaseType.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(10),
                to: now.minusDays(9),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(8),
                to: now.minusDays(7),
              ),
            ),
            CampaignPhase(
              title: 'Reviewers and Moderators registration',
              description: 'Description 1',
              type: CampaignPhaseType.reviewRegistration,
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
      expect(result.activePhases.length, equals(1));

      expect(
        result.activePhases.first.phase.type,
        equals(CampaignPhaseType.reviewRegistration),
      );

      expect(
        result.activePhases.first.status,
        equals(CampaignPhaseStatus.upcoming),
      );
    });

    test('state return closest phase that is post when there is no active phase', () {
      // Arrange
      final campaign = Campaign(
        id: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: _multiCurrency(100),
        fundNumber: 1,
        categories: const [],
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              type: CampaignPhaseType.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(10),
                to: now.minusDays(9),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(2),
                to: now.minusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Reviewers and Moderators registration',
              description: 'Description 1',
              type: CampaignPhaseType.reviewRegistration,
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
      expect(result.activePhases.length, equals(1));

      expect(
        result.activePhases.first.phase.type,
        equals(CampaignPhaseType.votingRegistration),
      );

      expect(
        result.activePhases.first.status,
        equals(CampaignPhaseStatus.post),
      );
    });

    test('state to return correct state for single phase', () {
      // Arrange
      final campaign = Campaign(
        id: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: _multiCurrency(100),
        fundNumber: 1,
        categories: const [],
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              type: CampaignPhaseType.proposalSubmission,
              timeline: DateRange(
                from: now.minusDays(10),
                to: now.minusDays(9),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
              timeline: DateRange(
                from: now.minusDays(1),
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Reviewers and Moderators registration',
              description: 'Description 1',
              type: CampaignPhaseType.reviewRegistration,
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
      final resultProposalSubmission = campaign.phaseStateTo(
        CampaignPhaseType.proposalSubmission,
        now,
      );
      final resultVotingRegistration = campaign.phaseStateTo(
        CampaignPhaseType.votingRegistration,
        now,
      );
      final resultReviewRegistration = campaign.phaseStateTo(
        CampaignPhaseType.reviewRegistration,
        now,
      );

      // Assert
      expect(
        resultProposalSubmission.phase.type,
        equals(CampaignPhaseType.proposalSubmission),
      );
      expect(resultProposalSubmission.status, equals(CampaignPhaseStatus.post));

      expect(
        resultVotingRegistration.phase.type,
        equals(CampaignPhaseType.votingRegistration),
      );
      expect(
        resultVotingRegistration.status,
        equals(CampaignPhaseStatus.active),
      );

      expect(
        resultReviewRegistration.phase.type,
        equals(CampaignPhaseType.reviewRegistration),
      );
      expect(
        resultReviewRegistration.status,
        equals(CampaignPhaseStatus.upcoming),
      );
    });

    test('campaign start date returns earliest phase start date', () {
      // Arrange
      final campaign = Campaign(
        id: SignedDocumentRef.generateFirstRef(),
        name: 'Campaign 1',
        description: 'Description 1',
        allFunds: _multiCurrency(100),
        fundNumber: 1,
        categories: const [],
        timeline: CampaignTimeline(
          phases: [
            CampaignPhase(
              title: 'Proposal Submission',
              description: 'Description 1',
              type: CampaignPhaseType.proposalSubmission,
              timeline: DateRange(
                from: now,
                to: now.plusDays(1),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
              timeline: DateRange(
                from: now.plusDays(2),
                to: now.plusDays(3),
              ),
            ),
            CampaignPhase(
              title: 'Voting Registration',
              description: 'Description 1',
              type: CampaignPhaseType.votingRegistration,
              timeline: DateRange(
                from: now.plusDays(4),
                to: now.plusDays(5),
              ),
            ),
          ],
        ),
        publish: CampaignPublish.published,
      );

      // Act
      final result = campaign.startDate;

      // Assert
      expect(result, equals(now));
    });
  });
}

Money _ada(int minorUnits) {
  return Money(
    currency: Currencies.ada,
    minorUnits: BigInt.from(minorUnits),
  );
}

MultiCurrencyAmount _multiCurrency(int minorUnits) {
  return MultiCurrencyAmount.list([
    _ada(minorUnits),
    _usdm(minorUnits),
  ]);
}

Money _usdm(int minorUnits) {
  return Money(
    currency: Currencies.usdm,
    minorUnits: BigInt.from(minorUnits),
  );
}
