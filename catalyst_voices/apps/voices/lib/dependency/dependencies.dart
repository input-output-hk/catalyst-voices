import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
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
          keyDerivationService: get<KeyDerivationService>(),
          progressNotifier: get<RegistrationProgressNotifier>(),
          blockchainConfig: get<AppConfig>().blockchain,
        );
      })
      ..registerLazySingleton<ProposalsCubit>(
        () => ProposalsCubit(
          get<UserService>(),
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
          get<ProposalService>(),
          get<DocumentMapper>(),
          get<DownloaderService>(),
        );
      })
      ..registerFactory<ProposalBuilderBloc>(() {
        return ProposalBuilderBloc(
          get<ProposalService>(),
          get<CampaignService>(),
          get<CommentService>(),
          get<UserService>(),
          get<DownloaderService>(),
          get<DocumentMapper>(),
        );
      })
      ..registerFactory<DiscoveryCubit>(() {
        return DiscoveryCubit(
          get<CampaignService>(),
          get<ProposalService>(),
        );
      })
      ..registerFactory<CategoryDetailCubit>(() {
        return CategoryDetailCubit(
          get<CampaignService>(),
        );
      })
      ..registerFactory<AccountCubit>(() {
        return AccountCubit(get<UserService>());
      })
      ..registerFactory<ProposalCubit>(() {
        return ProposalCubit(
          get<UserService>(),
          get<ProposalService>(),
          get<CommentService>(),
          get<CampaignService>(),
          get<DocumentMapper>(),
        );
      })
      ..registerFactory<NewProposalCubit>(() {
        return NewProposalCubit(
          get<CampaignService>(),
          get<ProposalService>(),
          get<UserObserver>(),
          get<DocumentMapper>(),
        );
      })
      ..registerFactory<CampaignStageCubit>(() {
        return CampaignStageCubit(get<CampaignService>());
      });
  }

  void _registerNetwork() {
    registerLazySingleton<ApiServices>(() {
      return ApiServices(
        config: get<AppConfig>().api,
        authTokenProvider: get<AuthTokenProvider>(),
      );
    });
  }

  void _registerRepositories() {
    this
      ..registerLazySingleton<UserRepository>(() {
        return UserRepository(
          get<UserStorage>(),
          get<KeychainProvider>(),
          get<ApiServices>(),
          get<DocumentRepository>(),
        );
      })
      ..registerLazySingleton<BlockchainRepository>(() {
        return BlockchainRepository(get<ApiServices>());
      })
      ..registerLazySingleton<SignedDocumentManager>(() {
        return const SignedDocumentManager();
      })
      ..registerLazySingleton<DatabaseDraftsDataSource>(() {
        return DatabaseDraftsDataSource(
          get<CatalystDatabase>(),
        );
      })
      ..registerLazySingleton<DatabaseDocumentsDataSource>(() {
        return DatabaseDocumentsDataSource(
          get<CatalystDatabase>(),
        );
      })
      ..registerLazySingleton<DocumentFavoriteSource>(() {
        return DatabaseDocumentFavoriteSource(
          get<CatalystDatabase>(),
        );
      })
      ..registerLazySingleton<CatGatewayDocumentDataSource>(() {
        return CatGatewayDocumentDataSource(
          get<ApiServices>(),
          get<SignedDocumentManager>(),
        );
      })
      ..registerLazySingleton<CampaignRepository>(CampaignRepository.new)
      ..registerLazySingleton<ConfigRepository>(ConfigRepository.new)
      ..registerLazySingleton<DocumentRepository>(() {
        return DocumentRepository(
          get<DatabaseDraftsDataSource>(),
          get<DatabaseDocumentsDataSource>(),
          get<CatGatewayDocumentDataSource>(),
          get<DocumentFavoriteSource>(),
        );
      })
      ..registerLazySingleton<DocumentMapper>(() => const DocumentMapperImpl())
      ..registerLazySingleton<ProposalRepository>(
        () => ProposalRepository(
          get<SignedDocumentManager>(),
          get<DocumentRepository>(),
          get<DatabaseDocumentsDataSource>(),
        ),
      )
      ..registerLazySingleton<CommentRepository>(
        () => CommentRepository(
          get<SignedDocumentManager>(),
          get<DocumentRepository>(),
        ),
      );
  }

  void _registerServices() {
    registerLazySingleton<CatalystKeyDerivation>(CatalystKeyDerivation.new);
    registerLazySingleton<KeyDerivationService>(() {
      return KeyDerivationService(get<CatalystKeyDerivation>());
    });
    registerLazySingleton<KeychainProvider>(() {
      return VaultKeychainProvider(
        secureStorage: get<FlutterSecureStorage>(),
        sharedPreferences: get<SharedPreferencesAsync>(),
        cacheConfig: get<AppConfig>().cache,
      );
    });
    registerLazySingleton<AuthTokenGenerator>(() {
      return AuthTokenGenerator(
        get<KeyDerivationService>(),
      );
    });
    registerLazySingleton<AuthService>(() {
      return AuthService(
        get<AuthTokenCache>(),
        get<UserObserver>(),
        get<AuthTokenGenerator>(),
      );
    });
    registerLazySingleton<AuthTokenProvider>(() => get<AuthService>());
    registerLazySingleton<DownloaderService>(DownloaderService.new);
    registerLazySingleton<CatalystCardano>(() => CatalystCardano.instance);
    registerLazySingleton<RegistrationProgressNotifier>(
      RegistrationProgressNotifier.new,
    );
    registerLazySingleton<RegistrationService>(() {
      return RegistrationService(
        get<UserService>(),
        get<BlockchainService>(),
        get<KeychainProvider>(),
        get<CatalystCardano>(),
        get<AuthTokenGenerator>(),
        get<KeyDerivationService>(),
        get<AppConfig>().blockchain,
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
    registerLazySingleton<BlockchainService>(() {
      return BlockchainService(
        get<BlockchainRepository>(),
      );
    });
    registerLazySingleton<SignerService>(() {
      return AccountSignerService(
        get<UserService>(),
        get<KeyDerivationService>(),
      );
    });
    registerLazySingleton<AccessControl>(AccessControl.new);
    registerLazySingleton<CampaignService>(() {
      return CampaignService(
        get<CampaignRepository>(),
        get<ProposalRepository>(),
      );
    });
    registerLazySingleton<ProposalService>(() {
      return ProposalService(
        get<ProposalRepository>(),
        get<DocumentRepository>(),
        get<UserService>(),
        get<SignerService>(),
        get<CampaignRepository>(),
      );
    });
    registerLazySingleton<CommentService>(() {
      return CommentService(
        get<CommentRepository>(),
        get<SignerService>(),
      );
    });
    registerLazySingleton<ConfigService>(() {
      return ConfigService(
        get<ConfigRepository>(),
      );
    });
    registerLazySingleton<DocumentsService>(() {
      return DocumentsService(
        get<DocumentRepository>(),
      );
    });
  }

  void _registerStorages() {
    registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    registerLazySingleton<SharedPreferencesAsync>(SharedPreferencesAsync.new);
    registerLazySingleton<UserStorage>(SecureUserStorage.new);
    registerLazySingleton<CatalystDatabase>(
      () {
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
      },
      dispose: (database) async => database.close(),
    );
    registerLazySingleton<AuthTokenCache>(() {
      return LocalAuthTokenCache(
        sharedPreferences: get<SharedPreferencesAsync>(),
      );
    });
  }

  void _registerUtils() {
    registerLazySingleton<SyncManager>(
      () {
        return SyncManager(
          get<DocumentsService>(),
        );
      },
      dispose: (manager) async => manager.dispose(),
    );
    registerLazySingleton<UserObserver>(
      StreamUserObserver.new,
      dispose: (observer) async => observer.dispose(),
    );
    registerLazySingleton<VideoManager>(
      () {
        return VideoManager();
      },
      dispose: (manager) => manager.dispose(),
    );
  }
}
