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
    _registerManagers();
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
      ..registerLazySingleton<SessionBloc>(() => SessionBloc())
      ..registerLazySingleton<UserProfileBloc>(() => UserProfileBloc());
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

  void _registerManagers() {
    registerLazySingleton(
      () => LoggingManager(),
      dispose: (manager) => manager.dispose(),
    );
  }
}
