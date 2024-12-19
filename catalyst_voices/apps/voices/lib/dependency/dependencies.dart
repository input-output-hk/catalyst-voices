import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class Dependencies extends DependencyProvider {
  static final Dependencies instance = Dependencies._();

  bool _isInitialized = false;

  Dependencies._();

  Future<void> init() async {
    DependencyProvider.instance = this;
    _registerServices();
    _registerRepositories();
    _registerBlocsWithDependencies();

    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;

  @override
  Future<void> get reset {
    return super.reset.whenComplete(() {
      _isInitialized = false;
    });
  }

  void _registerBlocsWithDependencies() {
    this
      ..registerSingleton<AuthenticationBloc>(
        AuthenticationBloc(
          authenticationRepository: get(),
        ),
      )
      ..registerLazySingleton<LoginBloc>(
        () => LoginBloc(
          authenticationRepository: get(),
        ),
      )
      ..registerLazySingleton<SessionCubit>(
        () {
          return SessionCubit(
            get<UserService>(),
            get<RegistrationService>(),
            get<RegistrationProgressNotifier>(),
          );
        },
        dispose: (cubit) async => cubit.close(),
      )
      // Factory will rebuild it each time needed
      ..registerFactory<RegistrationCubit>(() {
        return RegistrationCubit(
          downloader: get<Downloader>(),
          userService: get<UserService>(),
          registrationService: get<RegistrationService>(),
          progressNotifier: get<RegistrationProgressNotifier>(),
        );
      });
  }

  void _registerRepositories() {
    this
      ..registerLazySingleton<CredentialsStorageRepository>(
        () => CredentialsStorageRepository(storage: get()),
      )
      ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepository(credentialsStorageRepository: get()),
      )
      ..registerLazySingleton<TransactionConfigRepository>(
        TransactionConfigRepository.new,
      );
  }

  void _registerServices() {
    registerLazySingleton<Storage>(() => const SecureStorage());
    registerLazySingleton<CatalystKeyDerivation>(CatalystKeyDerivation.new);
    registerLazySingleton<KeyDerivation>(() => KeyDerivation(get()));
    registerLazySingleton<KeychainProvider>(VaultKeychainProvider.new);
    registerLazySingleton<DummyAuthStorage>(SecureDummyAuthStorage.new);
    registerLazySingleton<Downloader>(Downloader.new);
    registerLazySingleton<CatalystCardano>(() => CatalystCardano.instance);
    registerLazySingleton<UserStorage>(SecureUserStorage.new);
    registerLazySingleton<RegistrationProgressNotifier>(
      RegistrationProgressNotifier.new,
    );
    registerLazySingleton<RegistrationService>(() {
      return RegistrationService(
        transactionConfigRepository: get<TransactionConfigRepository>(),
        keychainProvider: get<KeychainProvider>(),
        cardano: get<CatalystCardano>(),
        keyDerivation: get<KeyDerivation>(),
      );
    });
    registerLazySingleton<UserService>(
      () {
        return UserService(
          keychainProvider: get<KeychainProvider>(),
          userStorage: get<UserStorage>(),
        );
      },
      dispose: (service) => unawaited(service.dispose()),
    );
  }
}
