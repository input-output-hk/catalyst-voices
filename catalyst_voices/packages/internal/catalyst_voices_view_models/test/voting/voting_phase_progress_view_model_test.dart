import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:test/test.dart';

void main() {
  group(VotingPhaseProgressViewModel, () {
    test('calculating progress before the voting starts', () {
      // Given
      final now = DateTime.utc(2025, 6, 10);

      // When
      final viewModel = VotingPhaseProgressViewModel(
        votingDateRange: DateRange(
          from: DateTime.utc(2025, 7, 10),
          to: DateTime.utc(2025, 7, 21),
        ),
        campaignStartDate: DateTime.utc(2025, 6),
      );

      // Then
      final actual = viewModel.progress(now);
      final expected = VotingPhaseProgressDetailsViewModel(
        status: CampaignPhaseStatus.upcoming,
        start: DateTime.utc(2025, 6),
        end: DateTime.utc(2025, 7, 10),
        phaseEndsIn: const Duration(hours: 720),
        progressValue: 0.23076,
      );

      _expectActualEqualsExpected(actual, expected);
    });

    test('calculating progress during the voting', () {
      // Given
      final now = DateTime.utc(2025, 7, 15);

      // When
      final viewModel = VotingPhaseProgressViewModel(
        votingDateRange: DateRange(
          from: DateTime.utc(2025, 7, 10),
          to: DateTime.utc(2025, 7, 21),
        ),
        campaignStartDate: DateTime.utc(2025, 6),
      );

      // Then
      final actual = viewModel.progress(now);
      final expected = VotingPhaseProgressDetailsViewModel(
        status: CampaignPhaseStatus.active,
        start: DateTime.utc(2025, 7, 10),
        end: DateTime.utc(2025, 7, 21),
        phaseEndsIn: const Duration(hours: 144),
        progressValue: 0.45454,
      );

      _expectActualEqualsExpected(actual, expected);
    });

    test('calculating progress after the voting', () {
      // Given
      final now = DateTime.utc(2025, 8, 15);

      // When
      final viewModel = VotingPhaseProgressViewModel(
        votingDateRange: DateRange(
          from: DateTime.utc(2025, 7, 10),
          to: DateTime.utc(2025, 7, 21),
        ),
        campaignStartDate: DateTime.utc(2025, 6),
      );

      // Then
      final actual = viewModel.progress(now);
      final expected = VotingPhaseProgressDetailsViewModel(
        status: CampaignPhaseStatus.post,
        start: DateTime.utc(2025, 7, 10),
        end: DateTime.utc(2025, 7, 21),
        phaseEndsIn: Duration.zero,
        progressValue: 1,
      );

      _expectActualEqualsExpected(actual, expected);
    });
  });
}

void _expectActualEqualsExpected(
  VotingPhaseProgressDetailsViewModel actual,
  VotingPhaseProgressDetailsViewModel expected,
) {
  expect(actual.status, equals(expected.status));
  expect(actual.start, equals(expected.start));
  expect(actual.end, equals(expected.end));
  expect(actual.phaseEndsIn, equals(expected.phaseEndsIn));
  expect(actual.progressValue, closeTo(expected.progressValue, 0.001));
}
