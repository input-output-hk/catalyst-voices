import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../matcher/request_matchers.dart';
import 'mock_chain.dart';
import 'mock_keychain.dart';
import 'mock_response.dart';

void main() {
  group(RbacAuthInterceptor, () {
    late final UserObserver userObserver;
    late final AuthTokenProvider authTokenProvider;
    late final RbacAuthInterceptor interceptor;
    late final Chain<String> chain;

    final Keychain keychain = MockKeychain();

    setUpAll(() {
      userObserver = StreamUserObserver();
      authTokenProvider = _MockAuthTokenProvider();
      interceptor = RbacAuthInterceptor(
        userObserver,
        authTokenProvider,
      );

      chain = MockChain<String>();

      registerFallbackValue(Request('X', Uri(), Uri()));
    });

    tearDownAll(() async {
      await userObserver.dispose();
    });

    setUp(() {
      when(() => keychain.id).thenAnswer((_) => const Uuid().v4());
      when(
        // ignore: discarded_futures
        () => authTokenProvider.createRbacToken(
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) => Future(() => const Uuid().v4()));

      userObserver.user = const User.empty();
    });

    tearDown(() {
      reset(chain);
      reset(keychain);
    });

    test(
        'when active account keychain is '
        'unlocked auth header is added', () async {
      // Given
      final request = Request('GET', Uri(), Uri());
      final requestResponse = MockResponse<String>();

      // When
      when(() => keychain.isUnlocked).thenAnswer((_) => Future.value(true));
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: true,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

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
      when(() => keychain.isUnlocked).thenAnswer((_) => Future.value(true));
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: true,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

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
      when(() => keychain.isUnlocked).thenAnswer((_) => Future.value(false));
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: true,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(
        (captured.single as Request).headers.containsKey(_authHeaderName),
        isFalse,
      );
    });

    test('when none account is active auth header is not added', () async {
      // Given
      final request = Request('GET', Uri(), Uri());
      final requestResponse = MockResponse<String>();

      // When
      when(() => chain.request).thenReturn(request);
      when(() => chain.proceed(any())).thenAnswer((_) => requestResponse);
      when(() => requestResponse.statusCode).thenAnswer((_) => 200);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: false,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

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
      const originalToken = 'expired_token';
      const refreshedToken = 'refreshed_token';

      final request = Request('GET', Uri(), Uri());

      final originalResponse = MockResponse<String>();
      final retryResponse = MockResponse<String>();

      // When
      when(() => keychain.isUnlocked).thenAnswer((_) => Future.value(true));
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
            that: containsHeaderValue(_buildAuthHeaderValue(originalToken)),
          ),
        );
      }).thenAnswer((_) => originalResponse);

      // Refreshed token
      when(() => authTokenProvider.createRbacToken(forceRefresh: true))
          .thenAnswer((_) => Future.value(refreshedToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(_buildAuthHeaderValue(refreshedToken)),
          ),
        );
      }).thenAnswer((_) => retryResponse);

      // Responses
      when(() => originalResponse.statusCode).thenAnswer((_) => 401);
      when(() => retryResponse.statusCode).thenAnswer((_) => 200);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: true,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(captured, hasLength(2));

      expect(
        captured.first,
        allOf(
          isA<Request>(),
          containsHeaderValue(_buildAuthHeaderValue(originalToken)),
          isNot(containsHeaderKey('Retry-Count')),
        ),
      );
      expect(
        captured[1],
        allOf(
          isA<Request>(),
          containsHeaderValue(_buildAuthHeaderValue(refreshedToken)),
          containsHeaderKey('Retry-Count'),
          containsHeaderValue('1'),
        ),
      );
    });

    test('403 response code triggers force token update', () async {
      // Given
      const originalToken = 'expired_token';
      const refreshedToken = 'refreshed_token';

      final request = Request('GET', Uri(), Uri());

      final originalResponse = MockResponse<String>();
      final retryResponse = MockResponse<String>();

      // When
      when(() => keychain.isUnlocked).thenAnswer((_) => Future.value(true));
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
            that: containsHeaderValue(_buildAuthHeaderValue(originalToken)),
          ),
        );
      }).thenAnswer((_) => originalResponse);

      // Refreshed token
      when(() => authTokenProvider.createRbacToken(forceRefresh: true))
          .thenAnswer((_) => Future.value(refreshedToken));
      when(() {
        return chain.proceed(
          any(
            that: containsHeaderValue(_buildAuthHeaderValue(refreshedToken)),
          ),
        );
      }).thenAnswer((_) => retryResponse);

      // Responses
      when(() => originalResponse.statusCode).thenAnswer((_) => 403);
      when(() => retryResponse.statusCode).thenAnswer((_) => 200);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: true,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(captured, hasLength(2));

      expect(
        captured.first,
        allOf(
          isA<Request>(),
          containsHeaderValue(_buildAuthHeaderValue(originalToken)),
          isNot(containsHeaderKey('Retry-Count')),
        ),
      );
      expect(
        captured[1],
        allOf(
          isA<Request>(),
          containsHeaderValue(_buildAuthHeaderValue(refreshedToken)),
          containsHeaderKey('Retry-Count'),
          containsHeaderValue('1'),
        ),
      );
    });

    test('token refresh gives up after 1st try', () async {
      // Given
      const originalToken = 'expired_token';
      final request = Request(
        'GET',
        Uri(),
        Uri(),
        headers: {'Retry-Count': '1'},
      );
      final originalResponse = MockResponse<String>();

      // When
      when(() => keychain.isUnlocked).thenAnswer((_) => Future.value(true));
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
            that: containsHeaderValue(_buildAuthHeaderValue(originalToken)),
          ),
        );
      }).thenAnswer((_) => originalResponse);

      // Responses
      when(() => originalResponse.statusCode).thenAnswer((_) => 403);

      final user = User(
        accounts: [
          Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
            isActive: true,
          ),
        ],
        settings: const UserSettings(),
      );

      userObserver.user = user;

      await interceptor.intercept(chain);

      // Then
      final captured = verify(() => chain.proceed(captureAny())).captured;

      expect(captured, hasLength(1));

      expect(
        captured.first,
        allOf(
          isA<Request>(),
          containsHeaderValue(_buildAuthHeaderValue(originalToken)),
          containsHeaderKey('Retry-Count'),
          containsHeaderValue('1'),
        ),
      );
    });
  });
}

const _authHeaderName = 'Authorization';

String _buildAuthHeaderValue(String value) => 'Bearer $value';

class _MockAuthTokenProvider extends Mock implements AuthTokenProvider {}
