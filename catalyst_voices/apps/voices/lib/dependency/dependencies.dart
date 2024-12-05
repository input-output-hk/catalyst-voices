import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

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
      ..registerLazySingleton<SessionCubit>(
        () {
          return SessionCubit(
            get<UserService>(),
            get<RegistrationService>(),
            get<RegistrationProgressNotifier>(),
            get<AccessControl>(),
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
      })
      ..registerLazySingleton<ProposalsCubit>(
        () => ProposalsCubit(proposalRepository: get<ProposalRepository>()),
      )
      ..registerFactory<CampaignDetailsBloc>(() {
        return CampaignDetailsBloc(
          get<CampaignRepository>(),
        );
      })
      ..registerLazySingleton<CampaignInfoCubit>(() {
        return CampaignInfoCubit(
          campaignService: get<CampaignService>(),
        );
      })
      // TODO(ryszard-schossler): add repository for campaign management
      ..registerLazySingleton<CampaignBuilderCubit>(
        CampaignBuilderCubit.new,
      );
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
      )
      ..registerLazySingleton<ProposalRepository>(ProposalRepository.new)
      ..registerLazySingleton<CampaignRepository>(CampaignRepository.new);
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

    registerLazySingleton<AccessControl>(AccessControl.new);

    registerLazySingleton<CampaignService>(
      () => CampaignService(get<CampaignRepository>()),
    );

  }
}
