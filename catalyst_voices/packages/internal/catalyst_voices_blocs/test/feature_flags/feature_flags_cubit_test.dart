import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(FeatureFlagsCubit, () {
    late FeatureFlagsRepository repository;
    late FeatureFlagsService service;
    late FeatureFlagsCubit cubit;

    setUp(() {
      repository = FeatureFlagsRepository(
        AppEnvironmentType.dev,
        AppConfig.dev(),
      );
      service = FeatureFlagsService(repository);
      cubit = FeatureFlagsCubit(service);
    });

    tearDown(() async {
      await cubit.close();
      await service.dispose();
    });

    group('initialization', () {
      test('initial state contains all features', () {
        expect(cubit.state.featureFlags, hasLength(Features.allFeatureFlags.length));
      });

      test('initial state reflects repository state', () {
        final isRepositoryVotingEnabled = repository.isEnabled(Features.voting);
        expect(cubit.state.isEnabled(Features.voting), isRepositoryVotingEnabled);
      });
    });

    group('stream subscription', () {
      blocTest<FeatureFlagsCubit, FeatureFlagsState>(
        'emits new state when service changes',
        build: () => cubit,
        act: (cubit) => service.setUserOverride(Features.voting, value: false),
        expect: () => [
          isA<FeatureFlagsState>().having(
            (s) => s.isEnabled(Features.voting),
            'voting enabled',
            isFalse,
          ),
        ],
      );

      blocTest<FeatureFlagsCubit, FeatureFlagsState>(
        'emits multiple states for multiple changes',
        build: () => cubit,
        act: (cubit) {
          service
            ..setUserOverride(Features.voting, value: false)
            ..setUserOverride(Features.voting, value: true);
        },
        expect: () => [
          isA<FeatureFlagsState>().having(
            (s) => s.isEnabled(Features.voting),
            'voting enabled',
            isFalse,
          ),
          isA<FeatureFlagsState>().having(
            (s) => s.isEnabled(Features.voting),
            'voting enabled',
            isTrue,
          ),
        ],
      );
    });

    group('user override', () {
      blocTest<FeatureFlagsCubit, FeatureFlagsState>(
        'setUserOverride emits new state',
        build: () => cubit,
        act: (cubit) => cubit.setUserOverride(Features.voting, value: false),
        expect: () => [
          isA<FeatureFlagsState>().having(
            (s) => s.isEnabled(Features.voting),
            'voting enabled',
            isFalse,
          ),
        ],
      );
    });
  });
}
