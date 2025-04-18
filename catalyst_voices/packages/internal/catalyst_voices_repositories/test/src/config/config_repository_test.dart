//ignore_for_file: avoid_dynamic_calls

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/fixture_reader.dart';

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
      configJson['blockchain']['host'] = changedHost;
      final remoteConfig = RemoteConfig.fromJson(configJson);

      const env = AppEnvironmentType.dev;

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final config = await repository.getConfig(env: env);

      // Then
      expect(config.version, remoteConfig.version);
      expect(config.blockchain.host.name, changedHost);
    });

    test(
        'partial remote config is using '
        'fallback values when missing', () async {
      // Given
      final configJson = await FixtureReader.readJson('config/no_chain');
      final remoteConfig = RemoteConfig.fromJson(configJson);

      const env = AppEnvironmentType.dev;
      final expectedChainConfig = AppConfig.env(env).blockchain;

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final config = await repository.getConfig(env: env);

      // Then
      expect(config.blockchain, equals(expectedChainConfig));
    });

    test('empty config fallbacks to default values', () async {
      // Given
      final configJson = await FixtureReader.readJson('config/empty');
      final remoteConfig = RemoteConfig.fromJson(configJson);

      const env = AppEnvironmentType.dev;
      const expectedConfig = AppConfig.dev();

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final config = await repository.getConfig(env: env);

      // Then
      expect(config, equals(expectedConfig));
    });
  });
}

final class _MockRemoteConfigSource extends Mock implements RemoteConfigSource {
  //
}
