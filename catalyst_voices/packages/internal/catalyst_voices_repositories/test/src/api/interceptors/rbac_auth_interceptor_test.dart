import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(RbacAuthInterceptor, () {
    late AuthTokenProvider authTokenProvider;
    late RbacAuthInterceptor interceptor;
    late RequestInterceptorHandler requestHandler;
    late ErrorInterceptorHandler errorHandler;

    setUp(() {
      authTokenProvider = _MockAuthTokenProvider();
      interceptor = RbacAuthInterceptor(authTokenProvider);
      requestHandler = _MockRequestInterceptorHandler();
      errorHandler = _MockErrorInterceptorHandler();

      when(
        () => authTokenProvider.createRbacToken(
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) => Future(() => RbacToken(const Uuid().v4())));
    });

    test(
      'when active account keychain is '
      'unlocked auth header is added',
      () async {
        // Given
        final options = RequestOptions(path: '/test');

        // When
        await interceptor.onRequest(options, requestHandler);

        // Then
        verify(() => requestHandler.next(options)).called(1);
        expect(options.headers[HttpHeaders.authorization], isNotNull);
      },
    );

    test('auth header value start with bearer', () async {
      // Given
      final options = RequestOptions(path: '/test');

      // When
      await interceptor.onRequest(options, requestHandler);

      // Then
      expect(options.headers[HttpHeaders.authorization], startsWith('Bearer '));
    });

    test(
      'when active account keychain is '
      'locked auth header is not added',
      () async {
        // Given
        final options = RequestOptions(path: '/test');

        // When
        when(() => authTokenProvider.createRbacToken()).thenAnswer((_) async => null);
        await interceptor.onRequest(options, requestHandler);

        // Then
        verify(() => requestHandler.next(options)).called(1);
        expect(options.headers.containsKey(HttpHeaders.authorization), isFalse);
      },
    );

    test('401 response code triggers force token update', () async {
      // Given
      final options = RequestOptions(
        path: '/test',
        extra: {
          RbacAuthInterceptor.interceptorAuthExtra: true,
        },
      );
      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 401,
        ),
      );

      // When
      await interceptor.onError(dioError, errorHandler);

      // Then
      verify(() => authTokenProvider.createRbacToken(forceRefresh: true)).called(1);
      expect(options.extra[RbacAuthInterceptor.retryCountExtra], '1');
    });

    test('403 response code triggers force token update', () async {
      // Given
      final options = RequestOptions(
        path: '/test',
        extra: {
          RbacAuthInterceptor.interceptorAuthExtra: true,
        },
      );
      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 403,
        ),
      );

      // When
      await interceptor.onError(dioError, errorHandler);

      // Then
      verify(() => authTokenProvider.createRbacToken(forceRefresh: true)).called(1);
      expect(options.extra[RbacAuthInterceptor.retryCountExtra], '1');
    });

    test('token refresh gives up after 1st try', () async {
      // Given
      final options = RequestOptions(
        path: '/test',
        extra: {RbacAuthInterceptor.retryCountExtra: '1'},
      );
      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 401,
        ),
      );

      // When
      await interceptor.onError(dioError, errorHandler);

      // Then
      verify(() => errorHandler.next(dioError)).called(1);
      verifyNever(() => authTokenProvider.createRbacToken(forceRefresh: true));
      expect(options.extra[RbacAuthInterceptor.retryCountExtra], '1');
    });
  });
}

class _MockAuthTokenProvider extends Mock implements AuthTokenProvider {}

class _MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class _MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
