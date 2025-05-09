import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGateway gateway = _MockedCatGateway();
  final CatReviews reviews = _MockedCatReviews();

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
      const configJson = '{}';
      final response = Response<Object>(http.Response('', 200), configJson);

      // When
      when(gateway.apiV1ConfigFrontendGet)
          .thenAnswer((_) => Future.value(response));

      // Then
      final config = await source.get();

      expect(config.blockchain, isNull);
      expect(config.sentry, isNull);
      expect(config.cache, isNull);
    });

    test('invalid type is falling back to empty', () async {
      // Given
      const configJson = '1';
      final response = Response<Object>(http.Response('', 200), configJson);

      // When
      when(gateway.apiV1ConfigFrontendGet)
          .thenAnswer((_) => Future.value(response));

      // Then
      final config = await source.get();

      expect(config.blockchain, isNull);
      expect(config.sentry, isNull);
      expect(config.cache, isNull);
    });

    test('invalid json is falling back to empty', () async {
      // Given
      const configJson = '[]';
      final response = Response<Object>(http.Response('', 200), configJson);

      // When
      when(gateway.apiV1ConfigFrontendGet)
          .thenAnswer((_) => Future.value(response));

      // Then
      final config = await source.get();

      expect(config.blockchain, isNull);
      expect(config.sentry, isNull);
      expect(config.cache, isNull);
    });
  });
}

class _MockedCatGateway extends Mock implements CatGateway {}

class _MockedCatReviews extends Mock implements CatReviews {}
