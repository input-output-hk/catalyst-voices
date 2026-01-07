import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_blockchain_config.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
<<<<<<< HEAD
  final CatGatewayService gateway = _MockedCatGateway();
  final CatReviewsService reviews = _MockedCatReviews();
  final CatStatusService status = _MockedCatStatus();
=======
  final CatGateway gateway = MockCatGateway();
  final CatReviews reviews = MockCatReviews();
  final CatStatus status = MockedCatStatus();
  final AppMetaService appMeta = MockedAppMetaService();
>>>>>>> feat/face-performance-optimization-3352

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
<<<<<<< HEAD

class _MockedCatGateway extends Mock implements CatGatewayService {}

class _MockedCatReviews extends Mock implements CatReviewsService {}

class _MockedCatStatus extends Mock implements CatStatusService {}
=======
>>>>>>> feat/face-performance-optimization-3352
