import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Dependencies extends DependencyProvider {
  static final Dependencies instance = Dependencies._();

  Dependencies._();

  Future<void> init({
    required AppConfig config,
  }) async {
    DependencyProvider.instance = this;

    registerSingleton<AppConfig>(config);

    _registerStorages();
    _registerServices();
    _registerRepositories();
    _registerBlocsWithDependencies();
  }

  void _registerBlocsWithDependencies() {
    this
      ..registerLazySingleton<AdminToolsCubit>(
        AdminToolsCubit.new,
      )
      ..registerLazySingleton<AdminTools>(
        () => get<AdminToolsCubit>(),
      )
      ..registerLazySingleton<SessionCubit>(
        () {
          return SessionCubit(
            get<UserService>(),
            get<RegistrationService>(),
            get<RegistrationProgressNotifier>(),
            get<AccessControl>(),
            get<AdminTools>(),
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
        () => ProposalsCubit(
          get<CampaignService>(),
          get<ProposalService>(),
          get<AdminTools>(),
        ),
      )
      ..registerFactory<CampaignDetailsBloc>(() {
        return CampaignDetailsBloc(
          get<CampaignRepository>(),
        );
      })
      ..registerLazySingleton<CampaignInfoCubit>(() {
        return CampaignInfoCubit(
          get<CampaignService>(),
          get<AdminTools>(),
        );
      })
      // TODO(ryszard-schossler): add repository for campaign management
      ..registerLazySingleton<CampaignBuilderCubit>(
        CampaignBuilderCubit.new,
      )
      ..registerFactory<WorkspaceBloc>(() {
        return WorkspaceBloc(
          get<CampaignService>(),
        );
      })
      ..registerFactory<WorkspaceEditorBloc>(() {
        return WorkspaceEditorBloc(
          get<CampaignService>(),
        );
      });
  }

  void _registerRepositories() {
    this
      ..registerLazySingleton<TransactionConfigRepository>(
        TransactionConfigRepository.new,
      )
      ..registerLazySingleton<ProposalRepository>(ProposalRepository.new)
      ..registerLazySingleton<CampaignRepository>(CampaignRepository.new)
      ..registerLazySingleton<ConfigRepository>(ConfigRepository.new)
      ..registerLazySingleton<UserRepository>(() {
        return UserRepository(
          get<UserStorage>(),
          get<KeychainProvider>(),
        );
      });
  }

  void _registerServices() {
    registerLazySingleton<Storage>(() => const SecureStorage());
    registerLazySingleton<CatalystKeyDerivation>(CatalystKeyDerivation.new);
    registerLazySingleton<KeyDerivation>(() => KeyDerivation(get()));
    registerLazySingleton<KeychainProvider>(() {
      return VaultKeychainProvider(
        secureStorage: get<FlutterSecureStorage>(),
        sharedPreferences: get<SharedPreferencesAsync>(),
        cacheConfig: get<AppConfig>().cache,
      );
    });
    registerLazySingleton<Downloader>(Downloader.new);
    registerLazySingleton<CatalystCardano>(() => CatalystCardano.instance);
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
          userRepository: get<UserRepository>(),
        );
      },
      dispose: (service) => unawaited(service.dispose()),
    );
    registerLazySingleton<AccessControl>(AccessControl.new);
    registerLazySingleton<CampaignService>(() {
      return CampaignService(
        get<CampaignRepository>(),
      );
    });
    registerLazySingleton<ProposalService>(() {
      return ProposalService(
        get<ProposalRepository>(),
      );
    });
    registerLazySingleton<ConfigService>(() {
      return ConfigService(
        get<ConfigRepository>(),
      );
    });
  }

  void _registerStorages() {
    registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    registerLazySingleton<SharedPreferencesAsync>(SharedPreferencesAsync.new);
    registerLazySingleton<UserStorage>(SecureUserStorage.new);
  }
}
