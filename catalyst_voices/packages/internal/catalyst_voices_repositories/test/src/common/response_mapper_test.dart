// test/response_mapper_test.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  chopper.Response<String> mockResponse({
    int statusCode = HttpStatus.ok,
    String body = '',
    Object? error,
  }) {
    return chopper.Response(
      http.Response(body, statusCode),
      body,
      error: error,
    );
  }

  chopper.Response<Uint8List> mockBinaryResponse({
    int statusCode = HttpStatus.ok,
    List<int> body = const [],
    Object? error,
  }) {
    return chopper.Response(
      http.Response.bytes(body, statusCode),
      Uint8List.fromList(body),
      error: error,
    );
  }

  group('ResponseMapper', () {
    test('successBodyBytesOrThrow returns bodyBytes when successful', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final response = mockBinaryResponse(body: bytes);

      final result = response.successBodyBytesOrThrow();
      expect(result, equals(bytes));
    });

    test('successBodyBytesOrThrow throws $NotFoundException for 404', () {
      final response = mockBinaryResponse(
        statusCode: HttpStatus.notFound,
      );

      expect(
        response.successBodyBytesOrThrow,
        throwsA(isA<NotFoundException>()),
      );
    });

    test('successBodyBytesOrThrow throws $ResourceConflictException for 409', () {
      final response = mockBinaryResponse(
        statusCode: HttpStatus.conflict,
      );

      expect(
        response.successBodyBytesOrThrow,
        throwsA(const ResourceConflictException()),
      );
    });

    test('successBodyBytesOrThrow throws $ApiErrorResponseException otherwise', () {
      final response = mockBinaryResponse(
        statusCode: HttpStatus.internalServerError,
        error: 'Internal Error',
      );

      expect(
        response.successBodyBytesOrThrow,
        throwsA(isA<ApiErrorResponseException>()),
      );
    });

    test('successBodyOrThrow returns body when successful', () {
      const body = 'Success!';
      final response = mockResponse(body: body);

      final result = response.successBodyOrThrow();
      expect(result, equals(body));
    });

    test('successBodyOrThrow throws $NotFoundException for 404', () {
      final response = mockResponse(statusCode: HttpStatus.notFound);

      expect(
        response.successBodyOrThrow,
        throwsA(isA<NotFoundException>()),
      );
    });

    test('successBodyOrThrow throws $ResourceConflictException for 409', () {
      final response = mockResponse(
        statusCode: HttpStatus.conflict,
      );

      expect(
        response.successBodyOrThrow,
        throwsA(const ResourceConflictException()),
      );
    });

    test('successBodyOrThrow throws $ApiErrorResponseException otherwise', () {
      final response = mockResponse(
        statusCode: HttpStatus.internalServerError,
        error: 'Internal Error',
      );

      expect(
        response.successBodyOrThrow,
        throwsA(isA<ApiErrorResponseException>()),
      );
    });
  });

  group('FutureResponseMapper', () {
    test('successBodyBytesOrThrow awaits and returns result', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final response = mockBinaryResponse(body: bytes);

      final futureResponse = Future.value(response);
      final result = await futureResponse.successBodyBytesOrThrow();
      expect(result, equals(bytes));
    });

    test('successBodyOrThrow awaits and returns result', () async {
      const body = 'Hello!';
      final response = mockResponse(body: body);

      final futureResponse = Future.value(response);
      final result = await futureResponse.successBodyOrThrow();
      expect(result, equals(body));
    });
  });
}
