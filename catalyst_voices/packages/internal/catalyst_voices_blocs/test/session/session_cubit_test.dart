import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late final KeychainProvider keychainProvider;
  late final UserRepository userRepository;

  late final UserService userService;
  late final RegistrationService registrationService;
  late final RegistrationProgressNotifier notifier;
  late final AccessControl accessControl;

  late AdminToolsCubit adminToolsCubit;
  late SessionCubit sessionCubit;

  setUpAll(() {
    alwaysAllowRegistration = false;

    FlutterSecureStorage.setMockInitialValues({});

    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;

    keychainProvider = VaultKeychainProvider(
      secureStorage: const FlutterSecureStorage(),
      sharedPreferences: SharedPreferencesAsync(),
      cacheConfig: const CacheConfig(),
    );
    userRepository = UserRepository(
      SecureUserStorage(),
      keychainProvider,
    );

    userService = UserService(
      userRepository: userRepository,
    );
    registrationService = _MockRegistrationService(
      keychainProvider,
      [
        _MockCardanoWallet(),
      ],
    );
    notifier = RegistrationProgressNotifier();
    accessControl = const AccessControl();
  });

  setUp(() {
    // each test might emit using this cubit, therefore we reset it here
    adminToolsCubit = AdminToolsCubit();

    // restart list of wallets to default one found.
    (registrationService as _MockRegistrationService).cardanoWallets = [
      _MockCardanoWallet(),
    ];

    sessionCubit = SessionCubit(
      userService,
      registrationService,
      notifier,
      accessControl,
      adminToolsCubit,
    );
  });

  tearDown(() async {
    await sessionCubit.close();

    final user = await userService.getUser();
    for (final account in user.accounts) {
      await userService.removeAccount(account);
    }

    await const FlutterSecureStorage().deleteAll();
    await SharedPreferencesAsync().clear();

    notifier.value = const RegistrationProgress();

    reset(registrationService);
  });

  group(SessionCubit, () {
    test('when no account is found session is in Visitor state', () async {
      // Given

      // When
      final account = userService.account;
      if (account != null) {
        await userService.removeAccount(account);
      }

      // Then
      expect(userService.account, isNull);
      expect(sessionCubit.state, isA<VisitorSessionState>());
    });

    test('when no keychain is found session is in Visitor state', () async {
      // Given

      // When
      final account = userService.account;
      if (account != null) {
        await userService.removeAccount(account);
      }

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.account, isNull);
      expect(sessionCubit.state, isA<VisitorSessionState>());
      expect(
        sessionCubit.state,
        const VisitorSessionState(
          isRegistrationInProgress: false,
          canCreateAccount: true,
        ),
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

      final account = userService.account;
      if (account != null) {
        await userService.removeAccount(account);
      }

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.account, isNull);
      expect(sessionCubit.state, isA<VisitorSessionState>());
      expect(
        sessionCubit.state,
        const VisitorSessionState(
          isRegistrationInProgress: true,
          canCreateAccount: true,
        ),
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

      final account = Account.dummy(keychain: keychain);

      await userService.useAccount(account);

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.account, isNotNull);
      expect(userService.account?.keychain.id, account.keychain.id);
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

      final account = Account.dummy(keychain: keychain);

      await userService.useAccount(account);
      await account.keychain.unlock(lockFactor);

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.account, isNotNull);
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

    group('can create account', () {
      test('is disabled when no cardano wallets are found', () async {
        // Given
        const cardanoWallets = <CardanoWallet>[];
        const expectedState = VisitorSessionState(
          isRegistrationInProgress: false,
          canCreateAccount: false,
        );
        final mockedService = (registrationService as _MockRegistrationService);

        // When

        // ignore: cascade_invocations
        mockedService.cardanoWallets = cardanoWallets;

        sessionCubit = SessionCubit(
          userService,
          registrationService,
          notifier,
          accessControl,
          adminToolsCubit,
        );

        // Gives time for stream to emit.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Then
        expect(sessionCubit.state, expectedState);
      });

      test('is enabled when at least one cardano wallets is found', () async {
        // Given
        final cardanoWallets = <CardanoWallet>[
          _MockCardanoWallet(),
        ];
        const expectedState = VisitorSessionState(
          isRegistrationInProgress: false,
          canCreateAccount: true,
        );
        final mockedService = (registrationService as _MockRegistrationService);

        // When

        // ignore: cascade_invocations
        mockedService.cardanoWallets = cardanoWallets;

        sessionCubit = SessionCubit(
          userService,
          registrationService,
          notifier,
          accessControl,
          adminToolsCubit,
        );

        // Gives time for stream to emit.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Then
        expect(sessionCubit.state, expectedState);
      });
    });
  });
}

class _MockRegistrationService extends Mock implements RegistrationService {
  final KeychainProvider keychainProvider;
  List<CardanoWallet> cardanoWallets;

  _MockRegistrationService(
    this.keychainProvider,
    this.cardanoWallets,
  );

  @override
  Future<List<CardanoWallet>> getCardanoWallets() {
    return Future.value(cardanoWallets);
  }

  @override
  Future<Account> registerTestAccount({
    required String keychainId,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  }) async {
    final keychain = await keychainProvider.create(keychainId);

    await keychain.setLock(lockFactor);
    await keychain.unlock(lockFactor);

    return Account.dummy(keychain: keychain);
  }
}

class _MockCardanoWallet extends Mock implements CardanoWallet {
  _MockCardanoWallet();
}
