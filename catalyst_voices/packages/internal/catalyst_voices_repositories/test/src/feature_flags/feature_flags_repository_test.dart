import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FeatureFlagsRepository repository;

  setUp(() {
    repository = FeatureFlagsRepository(
      AppEnvironmentType.dev,
      AppConfig.dev(),
    );
  });

  group(FeatureFlagsRepository, () {
    test('getAllInfo returns info for all features', () {
      final allInfo = repository.getAllInfo();

      expect(allInfo, hasLength(Features.allFeatures.length));
      expect(
        allInfo.map((e) => e.feature.type).toSet(),
        equals(Features.allFeatures.map((e) => e.type).toSet()),
      );
    });

    group('getInfo', () {
      test('returns disabled for unavailable feature in environment', () {
        repository = FeatureFlagsRepository(
          AppEnvironmentType.prod,
          AppConfig.prod(),
        );

        final info = repository.getInfo(Features.voting);

        expect(info.feature.type, equals(FeatureType.voting));
        expect(info.enabled, isFalse);
        expect(info.sourceType, equals(FeatureFlagSourceType.defaults));
      });

      test('respects user override priority', () {
        repository.setValue(
          sourceType: FeatureFlagSourceType.userOverride,
          feature: Features.voting,
          value: false,
        );

        final info = repository.getInfo(Features.voting);

        expect(info.enabled, isFalse);
        expect(info.sourceType, equals(FeatureFlagSourceType.userOverride));
      });

      test('respects runtime source when no user override', () {
        repository.setValue(
          sourceType: FeatureFlagSourceType.runtimeSource,
          feature: Features.voting,
          value: false,
        );

        final info = repository.getInfo(Features.voting);

        expect(info.enabled, isFalse);
        expect(info.sourceType, equals(FeatureFlagSourceType.runtimeSource));
      });

      test('user override takes precedence over runtime source', () {
        repository
          ..setValue(
            sourceType: FeatureFlagSourceType.runtimeSource,
            feature: Features.voting,
            value: false,
          )
          ..setValue(
            sourceType: FeatureFlagSourceType.userOverride,
            feature: Features.voting,
            value: true,
          );

        final info = repository.getInfo(Features.voting);

        expect(info.enabled, isTrue);
        expect(info.sourceType, equals(FeatureFlagSourceType.userOverride));
      });
    });

    test('isEnabled returns enabled state from getInfo', () {
      repository.setValue(
        sourceType: FeatureFlagSourceType.userOverride,
        feature: Features.voting,
        value: false,
      );

      expect(repository.isEnabled(Features.voting), isFalse);

      repository.setValue(
        sourceType: FeatureFlagSourceType.userOverride,
        feature: Features.voting,
        value: true,
      );

      expect(repository.isEnabled(Features.voting), isTrue);
    });

    group('setValue', () {
      test('removes value when set to null', () {
        repository.setValue(
          sourceType: FeatureFlagSourceType.userOverride,
          feature: Features.voting,
          value: false,
        );
        expect(repository.isEnabled(Features.voting), isFalse);

        repository.setValue(
          sourceType: FeatureFlagSourceType.userOverride,
          feature: Features.voting,
          value: null,
        );

        final info = repository.getInfo(Features.voting);

        // Should fall back to default (enabled in dev)
        expect(info.enabled, isTrue);
        expect(info.sourceType, equals(FeatureFlagSourceType.defaults));
      });

      test('throws for config source (read-only)', () {
        expect(
          () => repository.setValue(
            sourceType: FeatureFlagSourceType.config,
            feature: Features.voting,
            value: true,
          ),
          throwsArgumentError,
        );
      });

      test('throws for dart define source (read-only)', () {
        expect(
          () => repository.setValue(
            sourceType: FeatureFlagSourceType.dartDefine,
            feature: Features.voting,
            value: true,
          ),
          throwsArgumentError,
        );
      });

      test('throws for defaults source (not a real source)', () {
        expect(
          () => repository.setValue(
            sourceType: FeatureFlagSourceType.defaults,
            feature: Features.voting,
            value: true,
          ),
          throwsArgumentError,
        );
      });
    });
  });
}
