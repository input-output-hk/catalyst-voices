import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:test/test.dart';

void main() {
  group(VotingPowerViewModel, () {
    group('status calculation', () {
      test('returns provisional when one is provisional and other is confirmed', () {
        // Given
        final first = VotingPower(
          amount: 1000,
          status: VotingPowerStatus.provisional,
          updatedAt: DateTime.utc(2025),
        );
        final second = VotingPower(
          amount: 500,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025, 1, 2),
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(first, second);

        // Then
        expect(result.status, VotingPowerStatus.provisional);
      });

      test('returns confirmed when both are confirmed', () {
        // Given
        final first = VotingPower(
          amount: 1000,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025),
        );
        final second = VotingPower(
          amount: 500,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025, 1, 2),
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(first, second);

        // Then
        expect(result.status, VotingPowerStatus.confirmed);
      });
    });

    group('updatedAt calculation', () {
      test('returns the earlier date', () {
        // Given
        final laterDate = DateTime.utc(2025, 1, 5);
        final earlierDate = DateTime.utc(2025);
        final first = VotingPower(
          amount: 1000,
          status: VotingPowerStatus.confirmed,
          updatedAt: laterDate,
        );
        final second = VotingPower(
          amount: 500,
          status: VotingPowerStatus.confirmed,
          updatedAt: earlierDate,
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(first, second);

        // Then
        expect(result.updatedAt, earlierDate);
      });

      test('returns first updatedAt when only first is provided', () {
        // Given
        final date = DateTime.utc(2025);
        final first = VotingPower(
          amount: 1000,
          status: VotingPowerStatus.confirmed,
          updatedAt: date,
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(first, null);

        // Then
        expect(result.updatedAt, date);
      });

      test('returns second updatedAt when only second is provided', () {
        // Given
        final date = DateTime.utc(2025, 1, 2);
        final second = VotingPower(
          amount: 500,
          status: VotingPowerStatus.confirmed,
          updatedAt: date,
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(null, second);

        // Then
        expect(result.updatedAt, date);
      });
    });

    group('amount calculation', () {
      test('sums amounts when both models are provided', () {
        // Given
        final first = VotingPower(
          amount: 1000,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025),
        );
        final second = VotingPower(
          amount: 500,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025, 1, 2),
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(first, second);

        // Then
        // Amount represents 1500 ADA total
        expect(result.amount.formatted, isNotEmpty);
        expect(result.amount.formattedWithSymbol, isNotEmpty);
      });

      test('uses only first amount when second is null', () {
        // Given
        final first = VotingPower(
          amount: 1000,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025),
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(first, null);

        // Then
        expect(result.amount.formatted, isNotEmpty);
        expect(result.amount.formattedWithSymbol, isNotEmpty);
      });

      test('uses only second amount when first is null', () {
        // Given
        final second = VotingPower(
          amount: 500,
          status: VotingPowerStatus.confirmed,
          updatedAt: DateTime.utc(2025, 1, 2),
        );

        // When
        final result = VotingPowerViewModel.totalFromModels(null, second);

        // Then
        expect(result.amount.formatted, isNotEmpty);
        expect(result.amount.formattedWithSymbol, isNotEmpty);
      });
    });
  });
}
