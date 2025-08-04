import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(AppEnvironmentType, () {
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

    group('normalizedBaseUri', () {
      test('removes path params', () {
        // Given
        const host = 'https://app.dev.projectcatalyst.io';
        final base = Uri.parse('$host/discovery');
        final expectedBase = Uri.parse(host);

        // When
        final normalizedBase = AppEnvironmentType.normalizedBaseUri(base);

        // Then
        expect(normalizedBase, expectedBase);
      });

      test('keeps original when no path provided', () {
        // Given
        const host = 'https://app.dev.projectcatalyst.io';
        final base = Uri.parse(host);
        final expectedBase = Uri.parse(host);

        // When
        final normalizedBase = AppEnvironmentType.normalizedBaseUri(base);

        // Then
        expect(normalizedBase, expectedBase);
      });
    });
  });
}
