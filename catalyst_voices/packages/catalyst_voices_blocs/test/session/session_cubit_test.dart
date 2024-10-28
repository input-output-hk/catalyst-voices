import 'package:catalyst_voices_blocs/src/session/session.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late final KeychainProvider keychainProvider;
  late final UserStorage userStorage;

  late final UserService userService;
  late final RegistrationService registrationService;
  late final RegistrationProgressNotifier notifier;

  late SessionCubit sessionCubit;

  setUpAll(() {
    keychainProvider = VaultKeychainProvider();
    userStorage = SecureUserStorage();

    userService = UserService(
      keychainProvider: keychainProvider,
      userStorage: userStorage,
    );
    registrationService = _MockRegistrationService();
    notifier = RegistrationProgressNotifier();
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    sessionCubit = SessionCubit(userService, registrationService, notifier);
  });

  tearDown(() async {
    await sessionCubit.close();

    reset(registrationService);
  });

  test('when no keychain is found session is in Visitor state', () async {
    // Given

    // When
    await userService.removeCurrentAccount();

    // Then
    expect(userService.keychain, isNull);
    expect(sessionCubit.state, isA<VisitorSessionState>());
  });

  test('when no keychain is found session is in Visitor state', () async {
    // Given

    // When
    await userService.removeCurrentAccount();

    // Gives time for stream to emit.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Then
    expect(userService.keychain, isNull);
    expect(sessionCubit.state, isA<VisitorSessionState>());
    expect(
      sessionCubit.state,
      const VisitorSessionState(isRegistrationInProgress: false),
    );
  });

  test(
      'when no keychain is found but there is a registration progress '
      'session is in Visitor state with correct flag', () async {
    // Given
    final keychainProgress = KeychainProgress(
      seedPhrase: SeedPhrase(),
      password: 'Test1234',
    );

    // When
    notifier.value = RegistrationProgress(keychainProgress: keychainProgress);

    await userService.removeCurrentAccount();

    // Gives time for stream to emit.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Then
    expect(userService.keychain, isNull);
    expect(sessionCubit.state, isA<VisitorSessionState>());
    expect(
      sessionCubit.state,
      const VisitorSessionState(isRegistrationInProgress: true),
    );
  });

  test('when keychain is locked session is in Guest state', () async {
    // Given
    const keychainId = 'id';
    const lockFactor = PasswordLockFactor('Test1234');

    // When
    final keychain = await keychainProvider.create(keychainId);
    await keychain.setLock(lockFactor);
    await keychain.lock();

    await userService.useKeychain(keychainId);

    // Gives time for stream to emit.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Then
    expect(userService.keychain, isNotNull);
    expect(sessionCubit.state, isNot(isA<VisitorSessionState>()));
    expect(sessionCubit.state, isA<GuestSessionState>());
  });

  test('when keychain is unlocked session is in Active state', () async {
    // Given
    const keychainId = 'id';
    const lockFactor = PasswordLockFactor('Test1234');

    // When
    final keychain = await keychainProvider.create(keychainId);
    await keychain.setLock(lockFactor);

    await userService.useKeychain(keychainId);
    await userService.keychain?.unlock(lockFactor);

    // Gives time for stream to emit.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Then
    expect(userService.keychain, isNotNull);
    expect(sessionCubit.state, isNot(isA<VisitorSessionState>()));
    expect(sessionCubit.state, isNot(isA<GuestSessionState>()));
    expect(sessionCubit.state, isA<ActiveAccountSessionState>());
  });
}

class _MockRegistrationService extends Mock implements RegistrationService {}
