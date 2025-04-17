//ignore_for_file: avoid_dynamic_calls

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixture/fixture_reader.dart';

void main() {
  final remoteSource = _MockRemoteConfigSource();
  late final repository = ConfigRepository(remoteSource);

  tearDown(() {
    reset(remoteSource);
  });

  group(ConfigRepository, () {
    test('full remote config is mapped correctly', () async {
      // Given
      const changedHost = 'midnight';
      final configJson = await FixtureReader.readJson('config/full');
      configJson['environments']['prod']['blockchain']['host'] = changedHost;
      final remoteConfig = RemoteConfig.fromJson(configJson);

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final appConfigs = await repository.getAppConfigs();

      // Then
      expect(appConfigs.environments.length, AppEnvironmentType.values.length);

      expect(appConfigs.version, remoteConfig.version);
      expect(appConfigs.createdAt, remoteConfig.createdAt);

      final prodConfig = appConfigs.environments[AppEnvironmentType.prod];

      expect(prodConfig, isNotNull);
      expect(prodConfig!.blockchain.host.name, changedHost);
    });

    test(
        'partial remote config is using '
        'fallback values when missing', () async {
      // Given
      final configJson = await FixtureReader.readJson('config/no_prod');
      final remoteConfig = RemoteConfig.fromJson(configJson);

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final appConfigs = await repository.getAppConfigs();

      // Then
      expect(appConfigs.environments.length, AppEnvironmentType.values.length);
      final prodConfig = appConfigs.environments[AppEnvironmentType.prod];

      expect(prodConfig, isNotNull);
      expect(prodConfig, equals(const AppConfig.prod()));
    });

    test('empty config fallbacks to default values', () async {
      // Given
      final configJson = await FixtureReader.readJson('config/empty');
      final remoteConfig = RemoteConfig.fromJson(configJson);

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final appConfigs = await repository.getAppConfigs();

      // Then
      expect(appConfigs.environments.length, AppEnvironmentType.values.length);
    });
  });
}

final class _MockRemoteConfigSource extends Mock implements RemoteConfigSource {
  //
}
