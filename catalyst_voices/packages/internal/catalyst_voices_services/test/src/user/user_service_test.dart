import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(UserService, () {
    late final KeychainProvider keychainProvider;
    late final UserObserver userObserver;
    late UserRepository userRepository;
    late UserService service;

    setUpAll(() {
      final store = InMemorySharedPreferencesAsync.empty();
      SharedPreferencesAsyncPlatform.instance = store;
      FlutterSecureStorage.setMockInitialValues({});
      DummyCatalystIdFactory.registerDummyKeyFactory();

      keychainProvider = VaultKeychainProvider(
        secureStorage: const FlutterSecureStorage(),
        sharedPreferences: SharedPreferencesAsync(),
        cacheConfig: AppConfig.dev().cache,
      );
      userObserver = StreamUserObserver();
    });

    tearDownAll(() async {
      await userObserver.dispose();
    });

    setUp(() {
      userRepository = _FakeUserRepository();
      service = UserService(userRepository, userObserver);
    });

    tearDown(() async {
      userObserver.user = const User.empty();

      await const FlutterSecureStorage().deleteAll();
      await SharedPreferencesAsync().clear();
    });

    test('when registering account getter returns that account', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final account = Account.dummy(
        catalystId: DummyCatalystIdFactory.create(),
        keychain: keychain,
      );

      await service.registerAccount(account);

      // Then
      final currentAccount = service.user.activeAccount;

      expect(currentAccount?.catalystId, account.catalystId);
      expect(currentAccount?.isActive, isTrue);
    });

    test('when using account getter returns that account', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final account = Account.dummy(
        catalystId: DummyCatalystIdFactory.create(),
        keychain: keychain,
      );

      await service.useAccount(account);

      // Then
      final currentAccount = service.user.activeAccount;

      expect(currentAccount?.catalystId, account.catalystId);
      expect(currentAccount?.isActive, isTrue);
    });

    test(
        'when using a new account with the same catalystId '
        'the getter returns updated account', () async {
      // Given
      final oldKeychainId = const Uuid().v4();
      final newKeychainId = const Uuid().v4();
      final catalystId = DummyCatalystIdFactory.create();

      // When
      final oldKeychain = await keychainProvider.create(oldKeychainId);
      final oldAccount = Account.dummy(
        catalystId: catalystId,
        keychain: oldKeychain,
      );

      final newKeychain = await keychainProvider.create(newKeychainId);
      final newAccount = Account.dummy(
        catalystId: catalystId,
        keychain: newKeychain,
        isActive: true,
      );

      await service.useAccount(oldAccount);
      await service.useAccount(newAccount);

      // Then
      final currentAccount = service.user.activeAccount;

      expect(currentAccount, equals(newAccount));
      expect(currentAccount, isNot(oldAccount));
    });

    test('using different account emits update in stream', () async {
      // Given
      final keychainIdOne = const Uuid().v4();
      final keychainIdTwo = const Uuid().v4();

      // When
      final keychainOne = await keychainProvider.create(keychainIdOne);
      final keychainTwo = await keychainProvider.create(keychainIdTwo);
      final catalystIdOne = DummyCatalystIdFactory.create(
        host: CatalystIdHost.cardanoPreprod,
      );
      final catalystIdTwo = DummyCatalystIdFactory.create(
        host: CatalystIdHost.cardanoPreview,
      );

      final accountOne = Account.dummy(
        catalystId: catalystIdOne,
        keychain: keychainOne,
      );
      final accountTwo = Account.dummy(
        catalystId: catalystIdTwo,
        keychain: keychainTwo,
      );

      final accountStream = service.watchUser.map((user) => user.activeAccount);

      // Then
      expect(
        accountStream,
        emitsInOrder([
          isNull,
          predicate<Account?>((e) => e?.catalystId == accountOne.catalystId),
          predicate<Account?>((e) => e?.catalystId == accountTwo.catalystId),
          predicate<Account?>((e) => e?.catalystId == accountOne.catalystId),
          isNull,
        ]),
      );

      await service.useAccount(accountOne);
      await service.useAccount(accountTwo);

      await service.removeAccount(accountTwo);
      await service.removeAccount(accountOne);

      await service.dispose();
    });

    test(
      'accounts getter returns all keychains initialized local instances',
      () async {
        // Given
        final ids = List.generate(5, (_) => const Uuid().v4());

        // When
        final accounts = <Account>[];
        for (final id in ids) {
          final keychain = await keychainProvider.create(id);
          final account = Account.dummy(
            catalystId: DummyCatalystIdFactory.create(),
            keychain: keychain,
          );

          accounts.add(account);
        }

        await userRepository.saveUser(User.optional(accounts: accounts));

        // Then
        final user = await service.getUser();

        expect(
          user.accounts.map((e) => e.catalystId),
          accounts.map((e) => e.catalystId),
        );
      },
    );

    test('use last account restores previously stored', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final lastAccount = Account.dummy(
        catalystId: DummyCatalystIdFactory.create(),
        keychain: keychain,
        isActive: true,
      );

      final user = User.optional(accounts: [lastAccount]);
      await userRepository.saveUser(user);

      await service.useLastAccount();

      // Then
      expect(service.user.activeAccount, lastAccount);
    });

    test('use last account does nothing on clear instance', () async {
      // Given

      // When
      await service.useLastAccount();

      // Then
      expect(service.user.activeAccount, isNull);
    });

    test('remove current account clears current keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final account = Account.dummy(
        catalystId: DummyCatalystIdFactory.create(),
        keychain: keychain,
        isActive: true,
      );

      final user = User.optional(accounts: [account]);
      await userRepository.saveUser(user);

      await service.useLastAccount();

      // Then
      expect(service.user.activeAccount, isNotNull);

      await service.removeAccount(account);

      expect(service.user.activeAccount, isNull);
      expect(await keychain.isEmpty, isTrue);
      expect(await keychainProvider.exists(keychainId), isFalse);
    });

    group('updateSettings', () {
      test('value is different user is updated correctly', () async {
        // Given
        const initialUser = User.empty();
        const settings = UserSettings(
          theme: ThemePreferences.dark,
          timezone: TimezonePreferences.utc,
        );

        const expectedUser = User(accounts: [], settings: settings);

        // When
        await userRepository.saveUser(initialUser);

        await service.useLastAccount();

        await service.updateSettings(settings);

        // Then
        final user = service.user;

        expect(user, expectedUser);
      });

      test('value is different new user is emitted by stream', () async {
        // Given
        const initialUser = User.empty();
        const settings = UserSettings(
          theme: ThemePreferences.dark,
          timezone: TimezonePreferences.utc,
        );

        const expectedUser = User(accounts: [], settings: settings);

        // When
        userObserver.user = initialUser;

        final userStream = service.watchUser;

        expect(
          userStream,
          emitsInOrder([
            initialUser,
            expectedUser,
          ]),
        );

        // Then
        await service.useLastAccount();

        await service.updateSettings(settings);

        await service.dispose();
      });
    });

    group('getPreviousTransactionId', () {
      test('when no active account', () async {
        // Given
        const emptyUser = User.empty();

        // When
        userObserver.user = emptyUser;

        // Then
        expect(
          () async => service.getPreviousRegistrationTransactionId(),
          throwsA(isArgumentError),
        );
      });

      test('when has active account', () async {
        // Given
        final keychainId = const Uuid().v4();

        // When
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        );
        userObserver.user = User.optional(accounts: [account]);

        // Then
        expect(
          await service.getPreviousRegistrationTransactionId(),
          equals(_transactionHash),
        );
      });
    });

    group('updateActiveAccountDetails', () {
      setUp(() {
        userRepository = _MockUserRepository();
        service = UserService(userRepository, userObserver);

        registerFallbackValue(const User.empty());
      });

      tearDown(() {
        reset(userRepository);
      });

      test('user repository is not called when public status is not setup', () async {
        // Given
        final keychainId = const Uuid().v4();
        const publicStatus = AccountPublicStatus.notSetup;

        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        ).copyWith(publicStatus: publicStatus);
        final user = User.optional(accounts: [account]);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));

        await service.useLastAccount();
        await service.updateActiveAccountDetails();

        // Then
        verifyNever(() => userRepository.getAccountPublicProfile());

        final serviceUser = await service.getUser();
        expect(serviceUser, user);
      });

      test('user repository is called when public status is setup', () async {
        // Given
        final keychainId = const Uuid().v4();
        const publicStatus = AccountPublicStatus.verifying;

        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional('dev@iohk.com'),
          publicStatus: publicStatus,
        );
        final user = User.optional(accounts: [account]);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));
        when(() => userRepository.getAccountPublicProfile()).thenAnswer(
          (_) => Future.value(
            const AccountPublicProfile(
              email: '',
              status: AccountPublicStatus.verified,
            ),
          ),
        );

        await service.useLastAccount();
        await service.updateActiveAccountDetails();

        // Then
        verify(() => userRepository.getAccountPublicProfile()).called(1);
      });

      test('user account is updated when status changes', () async {
        // Given
        final keychainId = const Uuid().v4();
        const publicStatus = AccountPublicStatus.verifying;
        const updatedPublicStatus = AccountPublicStatus.verified;
        const publicProfile = AccountPublicProfile(email: '', status: updatedPublicStatus);

        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional('dev@iohk.com'),
          publicStatus: publicStatus,
        );
        final user = User.optional(accounts: [account]);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));
        when(() => userRepository.getAccountPublicProfile())
            .thenAnswer((_) => Future.value(publicProfile));

        await service.useLastAccount();
        await service.updateActiveAccountDetails();

        // Then
        expect(service.user.activeAccount?.publicStatus, updatedPublicStatus);
      });
    });

    group('updateAccount', () {
      setUp(() {
        userRepository = _MockUserRepository();
        service = UserService(userRepository, userObserver);

        registerFallbackValue(const User.empty());
      });

      tearDown(() {
        reset(userRepository);
      });

      test('when email is the same user is not updated', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'dev@iohk.com';

        final catalystId = DummyCatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional(currentEmail),
          publicStatus: AccountPublicStatus.verified,
        );
        final user = User.optional(accounts: [account]);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));

        await service.updateAccount(id: catalystId, email: updateEmail);

        // Then
        verifyNever(() => userRepository.saveUser(any()));
      });

      test('when email is the same public status is not updated or profile published', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'dev@iohk.com';

        final catalystId = DummyCatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional(currentEmail),
          publicStatus: AccountPublicStatus.verified,
        );
        final user = User.optional(accounts: [account]);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        userObserver.user = user;

        await service.updateAccount(id: catalystId, email: updateEmail);

        // Then
        verifyNever(
          () => userRepository.publishUserProfile(catalystId: catalystId, email: updateEmail),
        );

        final activeAccount = service.user.activeAccount;
        expect(activeAccount?.email, currentEmail);
        expect(activeAccount?.publicStatus, account.publicStatus);
      });

      test('returns did change false when email did not changed', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'dev@iohk.com';

        final catalystId = DummyCatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional(currentEmail),
          publicStatus: AccountPublicStatus.verified,
        );
        final user = User.optional(accounts: [account]);

        const expectedResult = AccountUpdateResult();

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        userObserver.user = user;

        final result = await service.updateAccount(id: catalystId, email: updateEmail);

        // Then
        expect(result, expectedResult);
      });

      test('returns did change true when email did changed', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'otherDev@iohk.com';

        final catalystId = DummyCatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional(currentEmail),
          publicStatus: AccountPublicStatus.verified,
        );
        final user = User.optional(accounts: [account]);
        const publicProfile = AccountPublicProfile(email: '', status: AccountPublicStatus.verified);

        const expectedResult = AccountUpdateResult(didChanged: true);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));
        when(
          () => userRepository.publishUserProfile(
            catalystId: catalystId,
            email: updateEmail,
          ),
        ).thenAnswer((_) => Future.value(publicProfile));

        userObserver.user = user;

        final didUpdateAccount = await service.updateAccount(id: catalystId, email: updateEmail);

        // Then
        expect(didUpdateAccount, expectedResult);
      });

      test(
          'returns has pending email change when '
          'public profile effective email did not change', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'otherDev@iohk.com';

        final catalystId = DummyCatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional(currentEmail),
          publicStatus: AccountPublicStatus.verified,
        );
        final user = User.optional(accounts: [account]);
        const publicProfile = AccountPublicProfile(
          email: currentEmail,
          status: AccountPublicStatus.verified,
        );

        const expectedResult = AccountUpdateResult(hasPendingEmailChange: true);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));
        when(
          () => userRepository.publishUserProfile(
            catalystId: catalystId,
            email: updateEmail,
          ),
        ).thenAnswer((_) => Future.value(publicProfile));

        userObserver.user = user;

        final didUpdateAccount = await service.updateAccount(id: catalystId, email: updateEmail);

        // Then
        expect(didUpdateAccount, expectedResult);
      });

      test(
          'returns has pending email change when '
          'public profile status downgraded', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'otherDev@iohk.com';

        final catalystId = DummyCatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        ).copyWith(
          email: const Optional(currentEmail),
          publicStatus: AccountPublicStatus.verified,
        );
        final user = User.optional(accounts: [account]);
        const publicProfile = AccountPublicProfile(
          email: updateEmail,
          status: AccountPublicStatus.verifying,
        );

        const expectedResult = AccountUpdateResult(hasPendingEmailChange: true);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));
        when(
          () => userRepository.publishUserProfile(
            catalystId: catalystId,
            email: updateEmail,
          ),
        ).thenAnswer((_) => Future.value(publicProfile));

        userObserver.user = user;

        final didUpdateAccount = await service.updateAccount(id: catalystId, email: updateEmail);

        // Then
        expect(didUpdateAccount, expectedResult);
      });
    });
  });
}

final _transactionHash = TransactionHash.fromHex(
  '4d3f576f26db29139981a69443c2325daa812cc353a31b5a4db794a5bcbb06c2',
);

class _FakeUserRepository extends Fake implements UserRepository {
  User? _user;

  @override
  Future<TransactionHash> getPreviousRegistrationTransactionId({
    required CatalystId catalystId,
  }) async {
    return _transactionHash;
  }

  @override
  Future<User> getUser() async => _user ?? const User.empty();

  @override
  Future<AccountPublicProfile> publishUserProfile({
    required CatalystId catalystId,
    required String email,
  }) async {
    return AccountPublicProfile(email: email, status: AccountPublicStatus.notSetup);
  }

  @override
  Future<void> saveUser(User user) async {
    _user = user;
  }
}

class _MockUserRepository extends Mock implements UserRepository {}
