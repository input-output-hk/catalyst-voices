import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class Dependencies extends DependencyProvider {
  static final Dependencies instance = Dependencies._();

  Dependencies._();

  Future<void> init() async {
    DependencyProvider.instance = this;
    _registerServices();
    _registerRepositories();
    _registerBlocsWithDependencies();
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
      ..registerLazySingleton<SessionBloc>(
        () => SessionBloc(get<Keychain>()),
      )
      // Factory will rebuild it each time needed
      ..registerFactory<RegistrationCubit>(() {
        return RegistrationCubit(
          downloader: get(),
          registrationService: get(),
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
    registerLazySingleton<KeyDerivation>(KeyDerivation.new);
    registerLazySingleton<KeychainProvider>(VaultKeychainProvider.new);
    registerLazySingleton<DummyAuthStorage>(SecureDummyAuthStorage.new);
    registerLazySingleton<Downloader>(Downloader.new);
    registerLazySingleton<CatalystCardano>(() => CatalystCardano.instance);
    registerLazySingleton<RegistrationService>(() {
      return RegistrationService(
        get<TransactionConfigRepository>(),
        get<KeychainProvider>(),
        get<CatalystCardano>(),
        get<KeyDerivation>(),
      );
    });
  }
}
