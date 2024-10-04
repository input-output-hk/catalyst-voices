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
      ..registerLazySingleton<SessionBloc>(SessionBloc.new)
      // Factory will rebuild it each time needed
      ..registerFactory<RegistrationCubit>(() {
        return RegistrationCubit(downloader: get());
      });
  }

  void _registerRepositories() {
    this
      ..registerSingleton<CredentialsStorageRepository>(
        CredentialsStorageRepository(storage: get()),
      )
      ..registerSingleton<AuthenticationRepository>(
        AuthenticationRepository(credentialsStorageRepository: get()),
      );
  }

  void _registerServices() {
    registerSingleton<Storage>(const SecureStorage());
    registerSingleton<Vault>(const SecureStorageVault());
    registerSingleton<DummyAuthStorage>(const SecureDummyAuthStorage());
    registerSingleton<Downloader>(Downloader());
  }
}
