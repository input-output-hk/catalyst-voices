import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(AppEnvironmentType, () {
    group('base url', () {
      test('dev base url is correct', () {
        // Given
        const type = AppEnvironmentType.dev;
        const expectedBaseUrl = 'https://app.dev.projectcatalyst.io';

        // When
        final baseUrl = type.baseUrl;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('preprod base url is correct', () {
        // Given
        const type = AppEnvironmentType.preprod;
        const expectedBaseUrl = 'https://app.preprod.projectcatalyst.io';

        // When
        final baseUrl = type.baseUrl;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('prod base url is correct', () {
        // Given
        const type = AppEnvironmentType.prod;
        const expectedBaseUrl = 'https://app.projectcatalyst.io';

        // When
        final baseUrl = type.baseUrl;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('relative base url is empty', () {
        // Given
        const type = AppEnvironmentType.relative;
        const expectedBaseUrl = '';

        // When
        final baseUrl = type.baseUrl;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });
    });

    group('gateway', () {
      test('url is correct for dev', () {
        // Given
        const type = AppEnvironmentType.dev;
        const expectedBaseUrl =
            'https://app.dev.projectcatalyst.io/api/gateway';

        // When
        final baseUrl = type.gateway;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for prod', () {
        // Given
        const type = AppEnvironmentType.prod;
        const expectedBaseUrl = 'https://app.projectcatalyst.io/api/gateway';

        // When
        final baseUrl = type.gateway;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for relative', () {
        // Given
        const type = AppEnvironmentType.relative;
        const expectedBaseUrl = '/api/gateway';

        // When
        final baseUrl = type.gateway;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });
    });

    group('reviews', () {
      test('url is correct for dev', () {
        // Given
        const type = AppEnvironmentType.dev;
        const expectedBaseUrl =
            'https://app.dev.projectcatalyst.io/api/reviews';

        // When
        final baseUrl = type.reviews;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for prod', () {
        // Given
        const type = AppEnvironmentType.prod;
        const expectedBaseUrl = 'https://app.projectcatalyst.io/api/reviews';

        // When
        final baseUrl = type.reviews;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for relative', () {
        // Given
        const type = AppEnvironmentType.relative;
        const expectedBaseUrl = '/api/reviews';

        // When
        final baseUrl = type.reviews;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });
    });
  });
}
