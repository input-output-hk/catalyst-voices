import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late final KeychainProvider keychainProvider;
  late final UserStorage userStorage;

  late final DummyUserFactory dummyUserFactory;
  late final UserService userService;
  late final RegistrationService registrationService;
  late final RegistrationProgressNotifier notifier;
  late final AccessControl accessControl;

  late AdminToolsCubit adminToolsCubit;
  late SessionCubit sessionCubit;

  setUpAll(() {
    keychainProvider = VaultKeychainProvider();
    userStorage = SecureUserStorage();

    dummyUserFactory = DummyUserFactory();
    userService = UserService(
      keychainProvider: keychainProvider,
      userStorage: userStorage,
      dummyUserFactory: dummyUserFactory,
    );
    registrationService = _MockRegistrationService();
    notifier = RegistrationProgressNotifier();
    accessControl = const AccessControl();
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});

    // each test might emit using this cubit, therefore we reset it here
    adminToolsCubit = AdminToolsCubit();

    sessionCubit = SessionCubit(
      userService,
      dummyUserFactory,
      registrationService,
      notifier,
      accessControl,
      adminToolsCubit,
    );
  });

  tearDown(() async {
    await sessionCubit.close();

    reset(registrationService);
  });

  group(SessionCubit, () {
    test('when no keychain is found session is in Visitor state', () async {
      // Given

      // When
      await userService.removeCurrentKeychain();

      // Then
      expect(userService.keychain, isNull);
      expect(sessionCubit.state, isA<VisitorSessionState>());
    });

    test('when no keychain is found session is in Visitor state', () async {
      // Given

      // When
      await userService.removeCurrentKeychain();

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

      await userService.removeCurrentKeychain();

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

    test('when admin tools enabled is in mocked state', () async {
      adminToolsCubit.emit(
        const AdminToolsState(
          enabled: true,
          campaignStage: CampaignStage.scheduled,
          sessionStatus: SessionStatus.actor,
        ),
      );

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(sessionCubit.state, isA<ActiveAccountSessionState>());
    });
  });
}

class _MockRegistrationService extends Mock implements RegistrationService {}
