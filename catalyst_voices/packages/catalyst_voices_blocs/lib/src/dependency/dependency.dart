import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/dependency/dependency_provider.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class Dependency extends DependencyProvider {
  static final Dependency instance = Dependency._();

  Dependency._();

  Future<void> init() async {
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
      );
  }

  void _registerRepositories() {
    this
      ..registerSingleton<CredentialsStorageRepository>(
        CredentialsStorageRepository(secureStorageService: get()),
      )
      ..registerSingleton<AuthenticationRepository>(
        AuthenticationRepository(credentialsStorageRepository: get()),
      );
  }

  void _registerServices() {
    registerSingleton<SecureStorageService>(
      SecureStorageService(),
    );
  }
}
