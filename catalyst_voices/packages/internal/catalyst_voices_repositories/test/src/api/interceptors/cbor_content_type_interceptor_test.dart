import 'package:catalyst_voices_repositories/src/api/interceptors/cbor_content_type_interceptor.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_chain.dart';
import 'mock_response.dart';

void main() {
  group(CborContentTypeInterceptor, () {
    late final CborContentTypeInterceptor interceptor;
    late final Chain<String> chain;

    setUpAll(() {
      interceptor = const CborContentTypeInterceptor();
      chain = MockChain<String>();
      registerFallbackValue(Request('X', Uri(), Uri()));
    });

    tearDown(() {
      reset(chain);
    });

    test('when intercepting a binary request correct header is added',
        () async {
      // Given
      final requestData = CborContentTypeInterceptor.supportedRequests.first;
      final request = Request(
        requestData.method,
        Uri(path: requestData.path),
        Uri(),
      );
      final requestResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;
      final headers = (captured.single as Request).headers;
      expect(
        headers[CborContentTypeInterceptor.headerKey],
        equals(CborContentTypeInterceptor.headerValue),
      );
    });

    test('when intercepting unsupported request no header is added', () async {
      // Given
      final request = Request('GET', Uri(), Uri());
      final requestResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;
      final headers = (captured.single as Request).headers;
      expect(
        headers[CborContentTypeInterceptor.headerKey],
        isNull,
      );
    });
  });
}
