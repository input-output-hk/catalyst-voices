//ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixture/configs.dart';

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
      final configJson = jsonDecode(Configs.full) as Map<String, dynamic>;
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

    test('partial remote config is using '
        'fallback values when missing', () async {
      // Given
      final configJson = jsonDecode(Configs.noChain) as Map<String, dynamic>;
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
      final configJson = jsonDecode(Configs.empty) as Map<String, dynamic>;
      final remoteConfig = RemoteConfig.fromJson(configJson);

      const env = AppEnvironmentType.dev;
      final expectedConfig = AppConfig.dev();

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final config = await repository.getConfig(env: env);

      // Then
      expect(config, equals(expectedConfig));
    });

    test('mainnet blockchain slot number config is decoded correctly', () async {
      // Given
      final configJson = jsonDecode(Configs.mainnetBlockchainSlotNumber) as Map<String, dynamic>;
      final remoteConfig = RemoteConfig.fromJson(configJson);

      final systemStartTimestamp = DateTime.utc(2020, 7, 29, 21, 44, 51);
      const systemStartSlot = 4492800;
      const slotLength = Duration(seconds: 1);

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      // Then
      final config = await repository.getConfig(env: AppEnvironmentType.dev);

      final slotNumberConfig = config.blockchain.slotNumberConfig;

      expect(slotNumberConfig.systemStartTimestamp, systemStartTimestamp);
      expect(slotNumberConfig.systemStartSlot, systemStartSlot);
      expect(slotNumberConfig.slotLength, slotLength);
    });

    test('testnet blockchain slot number config is decoded correctly', () async {
      // Given
      final configJson = jsonDecode(Configs.testnetBlockchainSlotNumber) as Map<String, dynamic>;
      final remoteConfig = RemoteConfig.fromJson(configJson);

      final systemStartTimestamp = DateTime.utc(2022, 6, 21);
      const systemStartSlot = 86400;
      const slotLength = Duration(seconds: 1);

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      // Then
      final config = await repository.getConfig(env: AppEnvironmentType.dev);

      final slotNumberConfig = config.blockchain.slotNumberConfig;

      expect(slotNumberConfig.systemStartTimestamp, systemStartTimestamp);
      expect(slotNumberConfig.systemStartSlot, systemStartSlot);
      expect(slotNumberConfig.slotLength, slotLength);
    });

    test('invalid Sentry DSN falls back to default config', () async {
      // Given
      final configJson = jsonDecode(Configs.invalidSentryDsn) as Map<String, dynamic>;
      final remoteConfig = RemoteConfig.fromJson(configJson);

      const env = AppEnvironmentType.dev;
      final expectedConfig = AppConfig.dev();

      // When
      when(remoteSource.get).thenAnswer((_) => Future.value(remoteConfig));

      final config = await repository.getConfig(env: env);

      // Then
      expect(config.sentry.dsn, expectedConfig.sentry.dsn);
      expect(config.sentry.environment, expectedConfig.sentry.environment);
    });
  });
}

final class _MockRemoteConfigSource extends Mock implements RemoteConfigSource {
  //
}
