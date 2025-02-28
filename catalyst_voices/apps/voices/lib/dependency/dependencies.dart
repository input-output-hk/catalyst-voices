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

  bool _isInitialized = false;

  Dependencies._();

  bool get isInitialized => _isInitialized;

  @override
  Future<void> get reset {
    return super.reset.whenComplete(() {
      _isInitialized = false;
    });
  }

  Future<void> init({
    required AppConfig config,
  }) async {
    DependencyProvider.instance = this;

    registerSingleton<AppConfig>(config);

    _registerStorages();
    _registerUtils();
    _registerNetwork();
    _registerRepositories();
    _registerServices();
    _registerBlocsWithDependencies();

    _isInitialized = true;
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
          downloaderService: get<DownloaderService>(),
          userService: get<UserService>(),
          registrationService: get<RegistrationService>(),
          progressNotifier: get<RegistrationProgressNotifier>(),
        );
      })
      ..registerLazySingleton<ProposalsCubit>(
        () => ProposalsCubit(
          get<CampaignService>(),
          get<ProposalService>(),
        ),
      )
      ..registerFactory<CampaignDetailsBloc>(() {
        return CampaignDetailsBloc(
          get<CampaignService>(),
        );
      })
      ..registerLazySingleton<CampaignInfoCubit>(() {
        return CampaignInfoCubit(
          get<CampaignService>(),
          get<AdminTools>(),
        );
      })
      // TODO(LynxLynxx): add repository for campaign management
      ..registerLazySingleton<CampaignBuilderCubit>(
        CampaignBuilderCubit.new,
      )
      ..registerFactory<WorkspaceBloc>(() {
        return WorkspaceBloc(
          get<CampaignService>(),
        );
      })
      ..registerFactory<ProposalBuilderBloc>(() {
        return ProposalBuilderBloc(
          get<CampaignService>(),
          get<ProposalService>(),
          get<DownloaderService>(),
        );
      })
      ..registerFactory<DiscoveryCubit>(() {
        return DiscoveryCubit(
          get<CampaignService>(),
        );
      })
      ..registerFactory<CategoryDetailCubit>(() {
        return CategoryDetailCubit(
          get<CampaignService>(),
        );
      })
      ..registerFactory<AccountCubit>(() {
        return AccountCubit(get<UserService>());
      });
  }

  void _registerNetwork() {
    registerLazySingleton<ApiServices>(() {
      return ApiServices(
        config: get<AppConfig>().api,
        userObserver: get<UserObserver>(),
      );
    });
  }

  void _registerRepositories() {
    this
      ..registerLazySingleton<UserRepository>(() {
        return UserRepository(
          get<UserStorage>(),
          get<KeychainProvider>(),
        );
      })
      ..registerLazySingleton<DatabaseDraftsDataSource>(() {
        return DatabaseDraftsDataSource(
          get<CatalystDatabase>(),
        );
      })
      ..registerLazySingleton<DocumentDataLocalSource>(() {
        return DatabaseDocumentsDataSource(
          get<CatalystDatabase>(),
        );
      })
      ..registerLazySingleton<CatGatewayDocumentDataSource>(() {
        return CatGatewayDocumentDataSource(
          get<SignedDocumentManager>(),
        );
      })
      ..registerLazySingleton<TransactionConfigRepository>(
        TransactionConfigRepository.new,
      )
      ..registerLazySingleton<ProposalRepository>(ProposalRepository.new)
      ..registerLazySingleton<CampaignRepository>(CampaignRepository.new)
      ..registerLazySingleton<ConfigRepository>(ConfigRepository.new)
      ..registerLazySingleton<DocumentRepository>(() {
        return DocumentRepository(
          get<DatabaseDraftsDataSource>(),
          get<DocumentDataLocalSource>(),
          get<CatGatewayDocumentDataSource>(),
        );
      });
  }

  void _registerServices() {
    registerLazySingleton<CatalystKeyDerivation>(CatalystKeyDerivation.new);
    registerLazySingleton<KeyDerivation>(() => KeyDerivation(get()));
    registerLazySingleton<KeychainProvider>(() {
      return VaultKeychainProvider(
        secureStorage: get<FlutterSecureStorage>(),
        sharedPreferences: get<SharedPreferencesAsync>(),
        cacheConfig: get<AppConfig>().cache,
      );
    });
    registerLazySingleton<DownloaderService>(DownloaderService.new);
    registerLazySingleton<CatalystCardano>(() => CatalystCardano.instance);
    registerLazySingleton<RegistrationProgressNotifier>(
      RegistrationProgressNotifier.new,
    );
    registerLazySingleton<RegistrationService>(() {
      return RegistrationService(
        get<TransactionConfigRepository>(),
        get<KeychainProvider>(),
        get<CatalystCardano>(),
        get<KeyDerivation>(),
      );
    });
    registerLazySingleton<UserService>(
      () {
        return UserService(
          get<UserRepository>(),
          get<UserObserver>(),
        );
      },
      dispose: (service) => unawaited(service.dispose()),
    );
    registerLazySingleton<AccessControl>(AccessControl.new);
    registerLazySingleton<CampaignService>(() {
      return CampaignService(
        get<CampaignRepository>(),
        get<DocumentRepository>(),
      );
    });
    registerLazySingleton<ProposalService>(() {
      return ProposalService(
        get<ProposalRepository>(),
        get<DocumentRepository>(),
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
    registerLazySingleton<CatalystDatabase>(() {
      final config = get<AppConfig>().database;

      return CatalystDatabase.drift(
        config: CatalystDriftDatabaseConfig(
          name: config.name,
          web: CatalystDriftDatabaseWebConfig(
            sqlite3Wasm: Uri.parse(config.webSqlite3Wasm),
            driftWorker: Uri.parse(config.webDriftWorker),
          ),
        ),
      );
    });
  }

  void _registerUtils() {
    registerLazySingleton<SignedDocumentManager>(SignedDocumentManager.new);
    registerLazySingleton<UserObserver>(
      StreamUserObserver.new,
      dispose: (observer) async => observer.dispose(),
    );
  }
}
