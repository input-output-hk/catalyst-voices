import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_registration_chain.dart';
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
    late UserRepository userRepository;
    late RegistrationStatusPoller poller;
    late final UserObserver userObserver;
    late UserService service;

    setUpAll(() {
      final store = InMemorySharedPreferencesAsync.empty();
      SharedPreferencesAsyncPlatform.instance = store;
      FlutterSecureStorage.setMockInitialValues({});
      CatalystIdFactory.registerDummyKeyFactory();

      keychainProvider = VaultKeychainProvider(
        secureStorage: const FlutterSecureStorage(),
        sharedPreferences: SharedPreferencesAsync(),
        cacheConfig: AppConfig.dev().cache,
        keychainSigner: FakeKeychainSigner(),
      );
      userObserver = StreamUserObserver();

      registerFallbackValue(CatalystId(host: '', role0Key: Uint8List(32)));
      poller = MockRegistrationStatusPoller();
      when(() => poller.start(any())).thenAnswer((_) => const Stream.empty());
      when(() => poller.stop()).thenAnswer((_) => {});
      when(() => poller.dispose()).thenAnswer((_) => Future(() {}));
    });

    tearDownAll(() async {
      await userObserver.dispose();
    });

    setUp(() {
      userRepository = FakeUserRepository();
      service = UserService(userRepository, userObserver, poller);
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
        catalystId: CatalystIdFactory.create(),
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
        catalystId: CatalystIdFactory.create(),
        keychain: keychain,
      );

      await service.useAccount(account);

      // Then
      final currentAccount = service.user.activeAccount;

      expect(currentAccount?.catalystId, account.catalystId);
      expect(currentAccount?.isActive, isTrue);
      expect(service.activeAccountId, equals(account.catalystId));
    });

    test('when using a new account with the same catalystId '
        'the getter returns updated account', () async {
      // Given
      final oldKeychainId = const Uuid().v4();
      final newKeychainId = const Uuid().v4();
      final catalystId = CatalystIdFactory.create();

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
      expect(service.activeAccountId, equals(newAccount.catalystId));
    });

    test('using different account emits update in stream', () async {
      // Given
      final keychainIdOne = const Uuid().v4();
      final keychainIdTwo = const Uuid().v4();

      // When
      final keychainOne = await keychainProvider.create(keychainIdOne);
      final keychainTwo = await keychainProvider.create(keychainIdTwo);
      final catalystIdOne = CatalystIdFactory.create();
      final catalystIdTwo = CatalystIdFactory.create(
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
            catalystId: CatalystIdFactory.create(),
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

    test('use local user restores previously stored', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final lastAccount = Account.dummy(
        catalystId: CatalystIdFactory.create(),
        keychain: keychain,
        isActive: true,
      );

      final user = User.optional(accounts: [lastAccount]);
      await userRepository.saveUser(user);

      await service.useLocalUser();

      // Then
      expect(service.user.activeAccount, lastAccount);
    });

    test('use local user does nothing on clear instance', () async {
      // Given

      // When
      await service.useLocalUser();

      // Then
      expect(service.user.activeAccount, isNull);
    });

    test('remove current account clears current keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final account = Account.dummy(
        catalystId: CatalystIdFactory.create(),
        keychain: keychain,
        isActive: true,
      );

      final user = User.optional(accounts: [account]);
      await userRepository.saveUser(user);

      await service.useLocalUser();

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

        await service.useLocalUser();

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
        await service.useLocalUser();

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
        final mockRepository = FakeUserRepository()
          ..previousRegistrationTransactionId = _transactionHash;
        final mockService = UserService(mockRepository, userObserver, poller);

        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final catalystId = CatalystIdFactory.create();
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        );
        final user = User.optional(accounts: [account]);

        userObserver.user = user;

        // Then
        expect(
          await mockService.getPreviousRegistrationTransactionId(),
          equals(_transactionHash),
        );
      });
    });

    group('recoverAccount', () {
      test('recover account will recover the first account', () async {
        // Given
        final keychainId = const Uuid().v4();

        // When
        final account = Account.dummy(
          catalystId: CatalystIdFactory.create(username: 'account1'),
          keychain: await keychainProvider.create(keychainId),
        );

        await service.recoverAccount(account);

        // Then
        final currentUser = service.user;
        final currentAccount = currentUser.activeAccount;

        expect(currentAccount?.catalystId, account.catalystId);
        expect(currentAccount?.isActive, isTrue);
      });

      test('recover account will remove other already existing accounts', () async {
        // Given
        final keychainId1 = const Uuid().v4();
        final keychainId2 = const Uuid().v4();

        // When
        final account1 = Account.dummy(
          catalystId: CatalystIdFactory.create(username: 'account1'),
          keychain: await keychainProvider.create(keychainId1),
        );

        final account2 = Account.dummy(
          catalystId: CatalystIdFactory.create(username: 'account2'),
          keychain: await keychainProvider.create(keychainId2),
        );

        await service.useAccount(account1);
        await service.recoverAccount(account2);

        // Then
        final currentUser = service.user;
        final currentAccount = currentUser.activeAccount;

        expect(currentAccount?.catalystId, account2.catalystId);
        expect(currentAccount?.isActive, isTrue);
        expect(currentUser.accounts, hasLength(1));
        expect(currentUser.accounts.first.catalystId, equals(account2.catalystId));
      });

      test('recover account will erase the same account which is being recovered', () async {
        // Given
        final keychainId1 = const Uuid().v4();
        final keychainId2 = const Uuid().v4();

        // When
        final keychain1 = await keychainProvider.create(keychainId1);
        final keychain2 = await keychainProvider.create(keychainId2);
        final account1 = Account.dummy(
          catalystId: CatalystIdFactory.create(username: 'account1'),
          keychain: keychain1,
        );
        final account2 = account1.copyWith(
          keychain: keychain2,
        );

        // write something to keychain so that's it's not empty
        await keychain1.setLock(_lockFactor);
        await keychain1.unlock(_lockFactor);
        await keychain1.setMasterKey(_masterKey);

        await service.useAccount(account1);
        await service.recoverAccount(account2);

        // Then
        final currentUser = service.user;
        final currentAccount = currentUser.activeAccount;

        expect(currentAccount?.catalystId, account2.catalystId);
        expect(currentAccount?.isActive, isTrue);
        expect(currentAccount?.keychain.id, keychainId2);
      });
    });

    group('refreshActiveAccountProfile', () {
      setUp(() {
        userRepository = MockUserRepository();
        when(
          () => userRepository.getRbacRegistration(catalystId: any(named: 'catalystId')),
        ).thenAnswer(
          (_) {
            const rbac = RbacRegistrationChain(catalystId: '');
            return Future.value(rbac);
          },
        );
        service = UserService(userRepository, userObserver, poller);

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
          catalystId: CatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        ).copyWith(publicStatus: publicStatus);
        final user = User.optional(accounts: [account]);

        // When
        when(() => userRepository.getUser()).thenAnswer((_) => Future.value(user));
        when(() => userRepository.saveUser(any())).thenAnswer((_) => Future(() {}));

        await service.useLocalUser();
        await service.refreshActiveAccountProfile();

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
        final account =
            Account.dummy(
              catalystId: CatalystIdFactory.create(),
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

        await service.useLocalUser();
        await service.refreshActiveAccountProfile();

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
        final account =
            Account.dummy(
              catalystId: CatalystIdFactory.create(),
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
        when(
          () => userRepository.getAccountPublicProfile(),
        ).thenAnswer((_) => Future.value(publicProfile));

        await service.useLocalUser();
        await service.refreshActiveAccountProfile();

        // Then
        expect(service.user.activeAccount?.publicStatus, updatedPublicStatus);
      });
    });

    group('updateAccount', () {
      setUp(() {
        userRepository = MockUserRepository();
        service = UserService(userRepository, userObserver, poller);

        registerFallbackValue(const User.empty());
      });

      tearDown(() {
        reset(userRepository);
      });

      test('when email is the same user is not updated', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'dev@iohk.com';

        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account =
            Account.dummy(
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

        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account =
            Account.dummy(
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

        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account =
            Account.dummy(
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

        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account =
            Account.dummy(
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

      test('returns has pending email change when '
          'public profile effective email did not change', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'otherDev@iohk.com';

        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account =
            Account.dummy(
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

      test('returns has pending email change when '
          'public profile status downgraded', () async {
        // Given
        const currentEmail = 'dev@iohk.com';
        const updateEmail = 'otherDev@iohk.com';

        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account =
            Account.dummy(
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

    group('watchUnlockedActiveAccount', () {
      tearDown(() async {
        userObserver.user = const User.empty();
        await service.dispose();
      });

      test('emits null when no active account', () async {
        // Given
        const emptyUser = User.empty();

        // When
        userObserver.user = emptyUser;
        final accountStream = service.watchUnlockedActiveAccount;

        // Then
        expect(
          accountStream,
          emitsInOrder([
            isNull,
          ]),
        );
      });

      test('emits null when active account keychain is locked', () async {
        // Given
        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        );

        // When
        await keychain.lock();
        userObserver.user = User.optional(accounts: [account]);

        final accountStream = service.watchUnlockedActiveAccount;

        // Then
        expect(
          accountStream,
          emitsInOrder([
            isNull,
          ]),
        );
      });

      test('emits account when active account keychain is unlocked', () async {
        // Given
        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        const lock = PasswordLockFactor('Test1234');
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        );

        // When
        await keychain.setLock(lock);
        await keychain.unlock(lock);
        userObserver.user = User.optional(accounts: [account]);

        final accountStream = service.watchUnlockedActiveAccount;

        // Then
        expect(
          accountStream,
          emitsInOrder([
            predicate<Account?>((e) => e?.catalystId == account.catalystId),
          ]),
        );
      });

      test('emits null then account when keychain unlocks', () async {
        // Given
        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        const lock = PasswordLockFactor('Test1234');
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        );

        // When
        await keychain.setLock(lock);
        await keychain.lock();
        userObserver.user = User.optional(accounts: [account]);

        final accountStream = service.watchUnlockedActiveAccount;

        // Then
        final expectation = expectLater(
          accountStream,
          emitsInOrder([
            isNull,
            predicate<Account?>((e) => e?.catalystId == account.catalystId),
          ]),
        );

        await keychain.unlock(lock);

        await expectation;
      });

      test('emits account then null when keychain locks', () async {
        // Given
        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        const lock = PasswordLockFactor('Test1234');
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        );

        // When
        await keychain.setLock(lock);
        await keychain.unlock(lock);
        userObserver.user = User.optional(accounts: [account]);

        final accountStream = service.watchUnlockedActiveAccount;

        // Then
        final expectation = expectLater(
          accountStream,
          emitsInOrder([
            predicate<Account?>((e) => e?.catalystId == account.catalystId),
            isNull,
          ]),
        );

        await Future<void>.delayed(Duration.zero);
        await keychain.lock();

        await expectation;
      });

      test('does not emit duplicate values when account state does not change', () async {
        // Given
        final catalystId = CatalystIdFactory.create();
        final keychainId = const Uuid().v4();
        const lock = PasswordLockFactor('Test1234');
        final keychain = await keychainProvider.create(keychainId);
        final account = Account.dummy(
          catalystId: catalystId,
          keychain: keychain,
          isActive: true,
        );

        // When
        await keychain.setLock(lock);
        await keychain.unlock(lock);
        userObserver.user = User.optional(accounts: [account]);

        final accountStream = service.watchUnlockedActiveAccount;
        final emittedValues = <Account?>[];

        final subscription = accountStream.listen(emittedValues.add);

        // Then
        // Trigger multiple updates that don't change the unlocked state
        userObserver.user = User.optional(accounts: [account]);
        await Future<void>.delayed(Duration.zero);
        userObserver.user = User.optional(accounts: [account]);
        await Future<void>.delayed(Duration.zero);

        // Modify account to trigger a new emission
        final modifiedAccount = account.copyWith(
          roles: {AccountRole.voter},
        );
        userObserver.user = User.optional(accounts: [modifiedAccount]);
        await Future<void>.delayed(Duration.zero);

        await subscription.cancel();

        expect(emittedValues.length, 2);
        expect(emittedValues.first?.catalystId, account.catalystId);
        expect(emittedValues.last?.catalystId, modifiedAccount.catalystId);
        expect(emittedValues.last?.roles, modifiedAccount.roles);
      });
    });
  });
}

const _lockFactor = PasswordLockFactor('Test1234');
final _masterKey = FakeCatalystPrivateKey(bytes: Uint8List.fromList(List.filled(32, 0)));

final _transactionHash = TransactionHash.fromHex(
  '4d3f576f26db29139981a69443c2325daa812cc353a31b5a4db794a5bcbb06c2',
);
