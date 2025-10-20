import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/cat_gateway_api_service.dart';
import 'package:catalyst_voices_repositories/src/api/cat_reviews_api_service.dart';
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
    test('returns remote config from gateway', () async {
      const remoteConfig = RemoteConfig();

      when(() => gateway.fetchFrontendConfig()).thenAnswer((_) async => remoteConfig);

      final config = await source.get();

      expect(config, same(remoteConfig));
    });

    test('falls back to empty config on error', () async {
      when(() => gateway.fetchFrontendConfig()).thenThrow(Exception('network error'));

      final config = await source.get();

      expect(config, const RemoteConfig());
    });
  });
}

class _MockedCatGateway extends Mock implements CatGatewayService {}

class _MockedCatReviews extends Mock implements CatReviewsService {}
