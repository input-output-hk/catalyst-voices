import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import 'mock_chain.dart';
import 'mock_keychain.dart';
import 'mock_response.dart';

const _authHeaderName = 'Authorization';

void main() {
  late final UserObserver userObserver;
  late final RbacAuthInterceptor interceptor;
  late final Chain<String> chain;

  final Keychain keychain = MockKeychain();

  setUpAll(() {
    userObserver = StreamUserObserver();
    interceptor = RbacAuthInterceptor(userObserver);

    chain = MockChain<String>();

    registerFallbackValue(Request('X', Uri(), Uri()));
  });

  tearDownAll(() async {
    await userObserver.dispose();
  });

  setUp(() {
    when(() => keychain.id).thenAnswer((_) => const Uuid().v4());

    userObserver.user = const User.empty();
  });

  tearDown(() {
    reset(chain);
    reset(keychain);
  });

  group(RbacAuthInterceptor, () {
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

      final user = User(
        accounts: [
          Account.dummy(keychain: keychain, isActive: true),
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

      final user = User(
        accounts: [
          Account.dummy(keychain: keychain, isActive: true),
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

      final user = User(
        accounts: [
          Account.dummy(keychain: keychain, isActive: true),
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

      final user = User(
        accounts: [
          Account.dummy(keychain: keychain, isActive: false),
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
  });
}
