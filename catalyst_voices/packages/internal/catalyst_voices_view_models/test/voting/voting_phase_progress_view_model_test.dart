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
        votingDateRange: viewModel.votingDateRange,
        currentPhaseEndsIn: const Duration(hours: 720),
        currentPhaseProgress: 0.23076,
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
        votingDateRange: viewModel.votingDateRange,
        currentPhaseEndsIn: const Duration(hours: 144),
        currentPhaseProgress: 0.45454,
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
        votingDateRange: viewModel.votingDateRange,
        currentPhaseEndsIn: Duration.zero,
        currentPhaseProgress: 1,
      );

      _expectActualEqualsExpected(actual, expected);
    });
  });
}

void _expectActualEqualsExpected(
  VotingPhaseProgressDetailsViewModel? actual,
  VotingPhaseProgressDetailsViewModel expected,
) {
  expect(actual, isNotNull);
  expect(actual!.status, equals(expected.status));
  expect(actual.votingDateRange, equals(expected.votingDateRange));
  expect(actual.currentPhaseEndsIn, equals(expected.currentPhaseEndsIn));
  expect(actual.currentPhaseProgress, closeTo(expected.currentPhaseProgress, 0.001));
}
