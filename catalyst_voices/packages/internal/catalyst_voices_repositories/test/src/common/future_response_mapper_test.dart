import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/common/future_response_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FutureResponseMapper', () {
    test('successBodyOrThrow returns body when successful', () async {
      const body = 'Success!';
      final futureResponse = Future.value(body);

      final result = await futureResponse.successBodyOrThrow();
      expect(result, equals(body));
    });

    test('successBodyOrThrow throws NotFoundException for 404', () async {
      final futureResponse = Future<String>.error(
        const ApiBadResponseException(
          statusCode: ApiResponseStatusCode.notFound,
          message: 'Not found',
        ),
      );

      await expectLater(
        futureResponse.successBodyOrThrow(),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('successBodyOrThrow throws UnauthorizedException for 401', () async {
      final futureResponse = Future<String>.error(
        const ApiBadResponseException(
          statusCode: ApiResponseStatusCode.unauthorized,
          message: 'Unauthorized',
        ),
      );

      await expectLater(
        futureResponse.successBodyOrThrow(),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('successBodyOrThrow throws ResourceConflictException for 409', () async {
      final futureResponse = Future<String>.error(
        const ApiBadResponseException(
          statusCode: ApiResponseStatusCode.conflict,
          message: 'Conflict',
        ),
      );

      await expectLater(
        futureResponse.successBodyOrThrow(),
        throwsA(isA<ResourceConflictException>()),
      );
    });

    test('successBodyOrThrow rethrows other ApiBadResponseException', () async {
      final futureResponse = Future<String>.error(
        const ApiBadResponseException(
          statusCode: ApiResponseStatusCode.internalServerError,
          message: 'Internal Error',
        ),
      );

      await expectLater(
        futureResponse.successBodyOrThrow(),
        throwsA(isA<ApiBadResponseException>()),
      );
    });

    test('successBodyOrThrow rethrows non-ApiBadResponseException errors', () async {
      final futureResponse = Future<String>.error(
        Exception('Some other error'),
      );

      await expectLater(
        futureResponse.successBodyOrThrow(),
        throwsA(isA<Exception>()),
      );
    });

    test('successBodyOrThrow extracts message from exception', () async {
      const errorMessage = 'Resource not found';
      final futureResponse = Future<String>.error(
        const ApiBadResponseException(
          statusCode: ApiResponseStatusCode.notFound,
          message: errorMessage,
        ),
      );

      try {
        await futureResponse.successBodyOrThrow();
        fail('Should have thrown NotFoundException');
      } on NotFoundException catch (e) {
        expect(e.message, equals(errorMessage));
      }
    });
  });
}
