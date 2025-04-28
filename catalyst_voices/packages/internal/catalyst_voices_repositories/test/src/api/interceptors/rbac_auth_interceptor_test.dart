import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../matcher/request_matchers.dart';
import 'mock_chain.dart';
import 'mock_response.dart';

void main() {
  group(RbacAuthInterceptor, () {
    late final AuthTokenProvider authTokenProvider;
    late final RbacAuthInterceptor interceptor;
    late final Chain<String> chain;

    setUpAll(() {
      authTokenProvider = _MockAuthTokenProvider();
      interceptor = RbacAuthInterceptor(authTokenProvider);

      chain = MockChain<String>();

      registerFallbackValue(Request('X', Uri(), Uri()));
    });

    setUp(() {
      when(
        // ignore: discarded_futures
        () => authTokenProvider.createRbacToken(
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) => Future(() => RbacToken(const Uuid().v4())));
    });

    tearDown(() {
      reset(chain);
    });

    test(
        'when active account keychain is '
        'unlocked auth header is added', () async {
      // Given
      final request = Request('GET', Uri(), Uri());
      final requestResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(
        (captured.single as Request).headers.containsKey(_authHeaderName),
        isTrue,
      );
    });

    test('auth header value start with bearer', () async {
      // Given
      final request = Request('GET', Uri(), Uri());
      final requestResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(
        (captured.single as Request).headers[_authHeaderName],
        startsWith('Bearer'),
      );
    });

    test(
        'when active account keychain is '
        'locked auth header is not added', () async {
      // Given
      final request = Request('GET', Uri(), Uri());
      final requestResponse = MockResponse<String>();

      // When
      when(() => authTokenProvider.createRbacToken())
          .thenAnswer((_) => Future.value(null));
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(
        (captured.single as Request).headers.containsKey(_authHeaderName),
        isFalse,
      );
    });

    test('401 response code triggers force token update', () async {
      // Given
      const originalToken = RbacToken('expired_token');
      const refreshedToken = RbacToken('refreshed_token');

      final request = Request('GET', Uri(), Uri());

      final originalResponse = MockResponse<String>();
      final retryResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);

      // Original token
      when(
        () => authTokenProvider.createRbacToken(
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) => Future.value(originalToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(originalToken.authHeader()),
          ),
        );
      }).thenAnswer((_) => originalResponse);

      // Refreshed token
      when(() => authTokenProvider.createRbacToken(forceRefresh: true))
          .thenAnswer((_) => Future.value(refreshedToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(refreshedToken.authHeader()),
          ),
        );
      }).thenAnswer((_) => retryResponse);

      // Responses
      when(() => originalResponse.statusCode).thenAnswer((_) => 401);
      when(() => retryResponse.statusCode).thenAnswer((_) => 200);

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(captured, hasLength(2));

      expect(
        captured.first,
        allOf(
          isA<Request>(),
          containsHeaderValue(originalToken.authHeader()),
          isNot(containsHeaderKey('Retry-Count')),
        ),
      );
      expect(
        captured[1],
        allOf(
          isA<Request>(),
          containsHeaderValue(refreshedToken.authHeader()),
          containsHeaderKey('Retry-Count'),
          containsHeaderValue('1'),
        ),
      );
    });

    test('403 response code triggers force token update', () async {
      // Given
      const originalToken = RbacToken('expired_token');
      const refreshedToken = RbacToken('refreshed_token');

      final request = Request('GET', Uri(), Uri());

      final originalResponse = MockResponse<String>();
      final retryResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);

      // Original token
      when(
        () => authTokenProvider.createRbacToken(
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) => Future.value(originalToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(originalToken.authHeader()),
          ),
        );
      }).thenAnswer((_) => originalResponse);

      // Refreshed token
      when(() => authTokenProvider.createRbacToken(forceRefresh: true))
          .thenAnswer((_) => Future.value(refreshedToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(refreshedToken.authHeader()),
          ),
        );
      }).thenAnswer((_) => retryResponse);

      // Responses
      when(() => originalResponse.statusCode).thenAnswer((_) => 403);
      when(() => retryResponse.statusCode).thenAnswer((_) => 200);

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(captured, hasLength(2));

      expect(
        captured.first,
        allOf(
          isA<Request>(),
          containsHeaderValue(originalToken.authHeader()),
          isNot(containsHeaderKey('Retry-Count')),
        ),
      );
      expect(
        captured[1],
        allOf(
          isA<Request>(),
          containsHeaderValue(refreshedToken.authHeader()),
          containsHeaderKey('Retry-Count'),
          containsHeaderValue('1'),
        ),
      );
    });

    test('token refresh gives up after 1st try', () async {
      // Given
      const originalToken = RbacToken('expired_token');
      final request = Request(
        'GET',
        Uri(),
        Uri(),
        headers: {'Retry-Count': '1'},
      );
      final originalResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);

      // Original token
      when(
        () => authTokenProvider.createRbacToken(
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) => Future.value(originalToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(originalToken.authHeader()),
          ),
        );
      }).thenAnswer((_) => originalResponse);

      // Responses
      when(() => originalResponse.statusCode).thenAnswer((_) => 403);

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(captured, hasLength(1));

      expect(
        captured.first,
        allOf(
          isA<Request>(),
          containsHeaderValue(originalToken.authHeader()),
          containsHeaderKey('Retry-Count'),
          containsHeaderValue('1'),
        ),
      );
    });
  });
}

const _authHeaderName = 'Authorization';

class _MockAuthTokenProvider extends Mock implements AuthTokenProvider {}
