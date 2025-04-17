import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

void main() {
  final client = _MockClient();

  setUpAll(() {
    UrlRemoteConfigSource.mockClient = client;

    registerFallbackValue(Uri());
  });

  tearDown(() {
    reset(client);
  });

  group(UrlRemoteConfigSource, () {
    test('relative path to endpoints is correct', () async {
      // Given
      final base = AppEnvironmentType.relative.gateway;
      final source = UrlRemoteConfigSource(baseUrl: base);

      final expectedUri = Uri.parse('$base/api/draft/config/frontend');

      // When
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) => Future.value(http.Response('{}', 200)));

      // Then
      await source.get();

      final uri = verify(() => client.get(captureAny())).captured.single as Uri;

      expect(uri, expectedUri);
    });

    test('dev path to endpoints is correct', () async {
      // Given
      final base = AppEnvironmentType.dev.gateway;
      final source = UrlRemoteConfigSource(baseUrl: base);

      final expectedUri = Uri.parse('$base/api/draft/config/frontend');

      // When
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) => Future.value(http.Response('{}', 200)));

      // Then
      await source.get();

      final uri = verify(() => client.get(captureAny())).captured.single as Uri;

      expect(uri, expectedUri);
    });
  });
}

class _MockClient extends Mock implements http.Client {}
