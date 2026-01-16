import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_blockchain_config.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGatewayService gateway = MockCatGateway();
  final CatReviewsService reviews = MockCatReviews();
  final CatStatusService status = MockedCatStatus();
  final AppMetaService appMeta = MockedAppMetaService();

  late final ApiServices apiServices;
  late final ApiConfigSource source;

  setUpAll(() {
    apiServices = ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
      status: status,
      appMeta: appMeta,
    );

    source = ApiConfigSource(apiServices);
  });

  tearDown(() {
    reset(gateway);
    reset(reviews);
    reset(status);
  });

  group(ApiConfigSource, () {
    test('empty config is parsed correctly', () async {
      // Given
      const remoteConfig = RemoteConfig();

      // When
      when(gateway.frontendConfig).thenAnswer((_) async => remoteConfig);

      // Then
      final config = await source.get();

      expect(config.blockchain, isNull);
      expect(config.sentry, isNull);
      expect(config.cache, isNull);
    });

    test('error is falling back to empty', () async {
      // When
      when(gateway.frontendConfig).thenThrow(Exception('network error'));

      // Then
      final config = await source.get();

      expect(config.blockchain, isNull);
      expect(config.sentry, isNull);
      expect(config.cache, isNull);
    });

    test('config with blockchain data is parsed correctly', () async {
      // Given
      final remoteConfig = RemoteConfig(
        blockchain: RemoteBlockchainConfig(networkId: 'mainnet'),
      );

      // When
      when(gateway.frontendConfig).thenAnswer((_) async => remoteConfig);

      // Then
      final config = await source.get();

      expect(config.blockchain?.networkId, 'mainnet');
    });
  });
}
