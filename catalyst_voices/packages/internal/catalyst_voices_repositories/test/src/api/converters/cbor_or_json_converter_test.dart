import 'package:catalyst_voices_repositories/src/api/converters/cbor_or_json_converter.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../interceptors/mock_response.dart';

void main() {
  group(CborOrJsonDelegateConverter, () {
    late MockConverter cborConverter;
    late MockConverter jsonConverter;
    late CborOrJsonDelegateConverter delegateConverter;

    setUpAll(() {
      registerFallbackValue(Request('X', Uri(), Uri()));
    });

    setUp(() {
      cborConverter = MockConverter();
      jsonConverter = MockConverter();
      delegateConverter = CborOrJsonDelegateConverter(
        cborConverter: cborConverter,
        jsonConverter: jsonConverter,
      );
    });

    test('delegates CBOR request to cborConverter', () async {
      final request = Request(
        'PUT',
        Uri.parse('https://example.com/api/v1/document'),
        Uri.parse('https://example.com/'),
        headers: {HttpHeaders.contentType: ContentTypes.applicationCbor},
      );

      when(() => cborConverter.convertRequest(any())).thenAnswer((_) => Future.value(request));

      final convertedRequest = await delegateConverter.convertRequest(request);
      expect(convertedRequest, equals(request));
      verify(() => cborConverter.convertRequest(request)).called(1);
      verifyNever(() => jsonConverter.convertRequest(request));
    });

    test('delegates non-CBOR request to jsonConverter', () async {
      final request = Request(
        'GET',
        Uri.parse('https://example.com/api/v1/other'),
        Uri.parse('https://example.com/'),
        headers: {HttpHeaders.contentType: ContentTypes.applicationJson},
      );

      when(() => jsonConverter.convertRequest(any())).thenAnswer((_) => Future.value(request));

      final convertedRequest = await delegateConverter.convertRequest(request);
      expect(convertedRequest, equals(request));
      verify(() => jsonConverter.convertRequest(request)).called(1);
      verifyNever(() => cborConverter.convertRequest(request));
    });

    test('delegates CBOR response to cborConverter', () async {
      final request = Request(
        'PUT',
        Uri.parse('https://example.com/api/v1/document'),
        Uri.parse('https://example.com/'),
      );

      final baseResponse = MockBaseResponse();
      final response = MockResponse<void>();
      when(() => response.headers)
          .thenReturn({HttpHeaders.contentType: ContentTypes.applicationCbor});
      when(() => response.base).thenReturn(baseResponse);
      when(() => baseResponse.request).thenReturn(request);
      when(() => cborConverter.convertResponse<void, void>(response)).thenReturn(response);

      final convertedResponse = delegateConverter.convertResponse<void, void>(response);
      expect(convertedResponse, equals(response));
      verify(() => cborConverter.convertResponse<void, void>(response)).called(1);
      verifyNever(() => jsonConverter.convertResponse<void, void>(response));
    });

    test('delegates non-CBOR response to jsonConverter', () async {
      final request = Request(
        'GET',
        Uri.parse('https://example.com/api/v1/other'),
        Uri.parse('https://example.com/'),
      );

      final baseResponse = MockBaseResponse();
      final response = MockResponse<void>();
      when(() => response.headers)
          .thenReturn({HttpHeaders.contentType: ContentTypes.applicationJson});
      when(() => response.base).thenReturn(baseResponse);
      when(() => baseResponse.request).thenReturn(request);
      when(() => jsonConverter.convertResponse<void, void>(response)).thenReturn(response);

      final convertedResponse = delegateConverter.convertResponse<void, void>(response);
      expect(convertedResponse, equals(response));
      verifyNever(() => cborConverter.convertResponse<void, void>(response));
      verify(() => jsonConverter.convertResponse<void, void>(response)).called(1);
    });
  });
}

class MockBaseResponse extends Mock implements http.BaseResponse {}

class MockConverter extends Mock implements Converter {}
