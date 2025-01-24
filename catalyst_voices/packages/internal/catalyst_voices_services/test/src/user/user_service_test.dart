import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:uuid/uuid.dart';

void main() {
  late final KeychainProvider keychainProvider;
  late final UserRepository userRepository;

  late UserService service;

  setUpAll(() {
    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;
    FlutterSecureStorage.setMockInitialValues({});

    keychainProvider = VaultKeychainProvider(
      secureStorage: const FlutterSecureStorage(),
      sharedPreferences: SharedPreferencesAsync(),
      cacheConfig: const CacheConfig(),
    );
    userRepository = UserRepository(SecureUserStorage(), keychainProvider);
  });

  setUp(() {
    service = UserService(
      userRepository: userRepository,
    );
  });

  tearDown(() async {
    await const FlutterSecureStorage().deleteAll();
    await SharedPreferencesAsync().clear();
  });

  group(UserService, () {
    test('when using account getter returns that account', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final account = Account.dummy(keychain: keychain);

      await service.useAccount(account);

      // Then
      final currentAccount = service.account;

      expect(currentAccount?.catalystId, account.catalystId);
      expect(currentAccount?.isActive, isTrue);
    });

    test('using different account emits update in stream', () async {
      // Given
      final keychainIdOne = const Uuid().v4();
      final keychainIdTwo = const Uuid().v4();

      // When
      final keychainOne = await keychainProvider.create(keychainIdOne);
      final keychainTwo = await keychainProvider.create(keychainIdTwo);
      final accountOne = Account.dummy(keychain: keychainOne);
      final accountTwo = Account.dummy(keychain: keychainTwo);

      final accountStream = service.watchAccount;

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

    test('accounts getter returns all keychains initialized local instances',
        () async {
      // Given
      final ids = List.generate(5, (_) => const Uuid().v4());

      // When
      final accounts = <Account>[];
      for (final id in ids) {
        final keychain = await keychainProvider.create(id);
        final account = Account.dummy(keychain: keychain);

        accounts.add(account);
      }

      await userRepository.saveUser(User(accounts: accounts));

      // Then
      final user = await service.getUser();

      expect(
        user.accounts.map((e) => e.catalystId),
        accounts.map((e) => e.catalystId),
      );
    });

    test('use last account restores previously stored', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final lastAccount = Account.dummy(
        keychain: keychain,
        isActive: true,
      );

      final user = User(accounts: [lastAccount]);
      await userRepository.saveUser(user);

      await service.useLastAccount();

      // Then
      expect(service.account, lastAccount);
    });

    test('use last account does nothing on clear instance', () async {
      // Given

      // When
      await service.useLastAccount();

      // Then
      expect(service.account, isNull);
    });

    test('remove current account clears current keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await keychainProvider.create(keychainId);
      final account = Account.dummy(
        keychain: keychain,
        isActive: true,
      );

      final user = User(accounts: [account]);
      await userRepository.saveUser(user);

      await service.useLastAccount();

      // Then
      expect(service.account, isNotNull);

      await service.removeAccount(account);

      expect(service.account, isNull);
      expect(await keychain.isEmpty, isTrue);
      expect(await keychainProvider.exists(keychainId), isFalse);
    });
  });
}
