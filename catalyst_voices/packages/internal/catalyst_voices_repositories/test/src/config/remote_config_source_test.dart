import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_blockchain_config.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGatewayService gateway = _MockedCatGateway();
  final CatReviewsService reviews = _MockedCatReviews();

  late final ApiServices apiServices;
  late final ApiConfigSource source;

  setUpAll(() {
    apiServices = ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
    );

    source = ApiConfigSource(apiServices);
  });

  tearDown(() {
    reset(gateway);
    reset(reviews);
  });

  group(ApiConfigSource, () {
    test('empty config is parsed correctly', () async {
      // Given
      const remoteConfig = RemoteConfig();

      // When
      when(gateway.fetchFrontendConfig).thenAnswer((_) async => remoteConfig);

      // Then
      final config = await source.get();

      expect(config.blockchain, isNull);
      expect(config.sentry, isNull);
      expect(config.cache, isNull);
    });

    test('error is falling back to empty', () async {
      // When
      when(gateway.fetchFrontendConfig).thenThrow(Exception('network error'));

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
      when(gateway.fetchFrontendConfig).thenAnswer((_) async => remoteConfig);

      // Then
      final config = await source.get();

      expect(config.blockchain?.networkId, 'mainnet');
    });
  });
}

class _MockedCatGateway extends Mock implements CatGatewayService {}

class _MockedCatReviews extends Mock implements CatReviewsService {}
