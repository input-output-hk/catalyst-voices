import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart' hide Uuid;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  late final KeychainProvider keychainProvider;
  late final FakeUserRepository userRepository;
  late final UserObserver userObserver;
  late final RegistrationStatusPoller poller;
  late final FakeFeatureFlagsRepository featureFlagsRepository;

  late final UserService userService;
  late final RegistrationService registrationService;
  late final RegistrationProgressNotifier notifier;
  late final AccessControl accessControl;
  late final FeatureFlagsService featureFlagService;
  late final ProposalService proposalService;

  late AdminToolsCubit adminToolsCubit;
  late SessionCubit sessionCubit;

  setUpAll(() {
    alwaysAllowRegistration = false;

    FlutterSecureStorage.setMockInitialValues({});

    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;

    CatalystIdFactory.registerDummyKeyFactory();

    keychainProvider = VaultKeychainProvider(
      secureStorage: const FlutterSecureStorage(),
      sharedPreferences: SharedPreferencesAsync(),
      cacheConfig: AppConfig.dev().cache,
      keychainSigner: FakeKeychainSigner(),
    );
    userRepository = FakeUserRepository();
    userObserver = StreamUserObserver();
    poller = _NoOpPoller();

    userService = UserService(
      userRepository,
      userObserver,
      poller,
    );

    registrationService = _MockRegistrationService(
      keychainProvider,
      [
        _MockCardanoWallet(),
      ],
    );
    notifier = RegistrationProgressNotifier();
    accessControl = const AccessControl();
    featureFlagsRepository = FakeFeatureFlagsRepository();
    featureFlagService = FeatureFlagsService(featureFlagsRepository);
    proposalService = _MockProposalService();
  });

  tearDownAll(() async {
    await userObserver.dispose();
    await userService.dispose();
    await featureFlagService.dispose();

    notifier.dispose();
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
      featureFlagService,
      proposalService,
    )..init();
  });

  tearDown(() async {
    await sessionCubit.close();

    final user = await userService.getUser();
    for (final account in user.accounts) {
      await userService.removeAccount(account);
    }
    userRepository.reset();

    await const FlutterSecureStorage().deleteAll();
    await SharedPreferencesAsync().clear();

    notifier.value = const RegistrationProgress();

    reset(registrationService);
  });

  group(SessionCubit, () {
    test('when no account is found session is in Visitor state', () async {
      // Given

      // When
      final account = userService.user.activeAccount;
      if (account != null) {
        await userService.removeAccount(account);
      }

      // Then
      expect(userService.user.activeAccount, isNull);
      expect(sessionCubit.state.status, SessionStatus.visitor);
    });

    test('when no keychain is found session is in Visitor state', () async {
      // Given

      // When
      final account = userService.user.activeAccount;
      if (account != null) {
        await userService.removeAccount(account);
      }

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.user.activeAccount, isNull);
      expect(sessionCubit.state.status, SessionStatus.visitor);
      expect(
        sessionCubit.state,
        const SessionState.visitor(
          isRegistrationInProgress: false,
          canCreateAccount: true,
        ),
      );
    });

    test('when no keychain is found but there is a registration progress '
        'session is in Visitor state with correct flag', () async {
      // Given
      final keychainProgress = KeychainProgress(
        keychainId: const Uuid().v4(),
        seedPhrase: SeedPhrase(),
        password: 'Test1234',
      );

      // When
      notifier.value = RegistrationProgress(keychainProgress: keychainProgress);

      final account = userService.user.activeAccount;
      if (account != null) {
        await userService.removeAccount(account);
      }

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.user.activeAccount, isNull);
      expect(sessionCubit.state.status, SessionStatus.visitor);
      expect(
        sessionCubit.state,
        const SessionState.visitor(
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

      final account = Account.dummy(
        catalystId: CatalystIdFactory.create(),
        keychain: keychain,
      );

      await userService.useAccount(account);

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.user.activeAccount, isNotNull);

      expect(userService.user.activeAccount?.keychain.id, account.keychain.id);
      expect(sessionCubit.state.status, SessionStatus.guest);
    });

    test('when keychain is unlocked session is in Active state', () async {
      // Given
      const keychainId = 'id';
      const lockFactor = PasswordLockFactor('Test1234');

      // When
      final keychain = await keychainProvider.create(keychainId);
      await keychain.setLock(lockFactor);

      final account = Account.dummy(
        catalystId: CatalystIdFactory.create(),
        keychain: keychain,
      );

      await userService.useAccount(account);
      await account.keychain.unlock(lockFactor);

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Then
      expect(userService.user.activeAccount, isNotNull);
      expect(sessionCubit.state.status, SessionStatus.actor);
    });

    test('when admin tools enabled is in mocked state', () async {
      adminToolsCubit.emit(
        const AdminToolsState(
          enabled: true,
        ),
      );

      // Gives time for stream to emit.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(sessionCubit.state.status, SessionStatus.actor);
    });

    group('can create account', () {
      test('is disabled when no cardano wallets are found', () async {
        // Given
        const cardanoWallets = <CardanoWallet>[];
        const expectedState = SessionState.visitor(
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
          featureFlagService,
          proposalService,
        )..init();

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
        const expectedState = SessionState.visitor(
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
          featureFlagService,
          proposalService,
        )..init();

        // Gives time for stream to emit.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Then
        expect(sessionCubit.state, expectedState);
      });
    });
  });
}

class _MockCardanoWallet extends Mock implements CardanoWallet {
  _MockCardanoWallet();
}

final class _MockProposalService extends Mock implements ProposalService {
  @override
  Stream<AccountInvitesApprovalsCount> watchInvitesApprovalsCount({required CatalystId id}) {
    return Stream.value(const AccountInvitesApprovalsCount(invitesCount: 0, approvalsCount: 0));
  }
}

class _MockRegistrationService extends Mock implements RegistrationService {
  final KeychainProvider keychainProvider;
  List<CardanoWallet> cardanoWallets;

  _MockRegistrationService(
    this.keychainProvider,
    this.cardanoWallets,
  );

  @override
  Future<Account> createDummyAccount() async {
    final catalystId = CatalystIdFactory.create();

    final keychain = await keychainProvider.create(Account.dummyKeychainId);

    await keychain.setLock(Account.dummyUnlockFactor);
    await keychain.unlock(Account.dummyUnlockFactor);

    return Account.dummy(
      catalystId: catalystId,
      keychain: keychain,
    );
  }

  @override
  Future<List<CardanoWallet>> getCardanoWallets() {
    return Future.value(cardanoWallets);
  }
}

final class _NoOpPoller implements RegistrationStatusPoller {
  @override
  Future<void> dispose() async {}

  @override
  Stream<CatalystIdRegStatus> start(CatalystId catalystId) => const Stream.empty();

  @override
  void stop() {}
}
