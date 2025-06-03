import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(AppEnvironmentType, () {
    group('gateway', () {
      test('url is correct for dev', () {
        // Given
        const type = AppEnvironmentType.dev;
        const expectedBaseUrl = 'https://app.dev.projectcatalyst.io/api/gateway';

        // When
        final baseUrl = type.appGatewayApi;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for prod', () {
        // Given
        const type = AppEnvironmentType.prod;
        const expectedBaseUrl = 'https://app.projectcatalyst.io/api/gateway';

        // When
        final baseUrl = type.appGatewayApi;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for relative', () {
        // Given
        const type = AppEnvironmentType.relative;
        const expectedBaseUrl = '/api/gateway';

        // When
        final baseUrl = type.appGatewayApi;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });
    });

    group('reviews', () {
      test('url is correct for dev', () {
        // Given
        const type = AppEnvironmentType.dev;
        const expectedBaseUrl = 'https://app.dev.projectcatalyst.io/api/reviews';

        // When
        final baseUrl = type.appReviewsApi;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for prod', () {
        // Given
        const type = AppEnvironmentType.prod;
        const expectedBaseUrl = 'https://app.projectcatalyst.io/api/reviews';

        // When
        final baseUrl = type.appReviewsApi;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });

      test('url is correct for relative', () {
        // Given
        const type = AppEnvironmentType.relative;
        const expectedBaseUrl = '/api/reviews';

        // When
        final baseUrl = type.appReviewsApi;

        // Then
        expect(baseUrl.toString(), expectedBaseUrl);
      });
    });

    group('tryUriBaseEnvName', () {
      test('returns dev correctly for dev base url', () {
        // Given
        const url = 'https://app.dev.projectcatalyst.io';
        const expectedEnv = 'dev';

        // When
        final envName = AppEnvironmentType.tryUriBaseEnvName(from: url);

        // Then
        expect(envName, expectedEnv);
      });

      test('returns null correctly for prod base url', () {
        // Given
        const url = 'https://app.projectcatalyst.io';
        const String? expectedEnv = null;

        // When
        final envName = AppEnvironmentType.tryUriBaseEnvName(from: url);

        // Then
        expect(envName, expectedEnv);
      });

      test('returns null correctly for localhost base url', () {
        // Given
        const url = 'http://localhost:8080';
        const String? expectedEnv = null;

        // When
        final envName = AppEnvironmentType.tryUriBaseEnvName(from: url);

        // Then
        expect(envName, expectedEnv);
      });
    });
  });
}
