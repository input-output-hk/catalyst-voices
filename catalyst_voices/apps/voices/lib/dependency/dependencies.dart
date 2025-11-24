import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/permissions/permission_handler_factory.dart';
import 'package:catalyst_voices/share/resource_url_resolver.dart';
import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart' as path;
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
    required AppEnvironment environment,
    required LoggingService loggingService,
    required ReportingService reportingService,
    CatalystProfiler? profiler,
    CatalystStartupProfiler? startupProfiler,
  }) async {
    DependencyProvider.instance = this;

    registerSingleton<AppConfig>(config);
    registerSingleton<AppEnvironment>(environment);
    registerSingleton<LoggingService>(loggingService);
    registerSingleton<ReportingService>(reportingService);
    if (profiler != null) {
      registerSingleton<CatalystProfiler>(profiler);
    }
    if (startupProfiler != null) {
      registerSingleton(startupProfiler);
    }

    _registerStorages();
    _registerUtils();
    _registerNetwork();
    _registerRepositories();
    _registerServices();
    _registerBlocsWithDependencies();

    _isInitialized = true;
  }

  void register<T extends Object>(T instance) {
    if (isRegistered<T>()) {
      if (kDebugMode) {
        print('${T.runtimeType} already registered!');
      }
    }
    registerSingleton<T>(instance);
  }

  void _registerBlocsWithDependencies() {
    this
      ..registerLazySingleton<AdminToolsCubit>(
        AdminToolsCubit.new,
      )
      ..registerLazySingleton<AdminTools>(
        () => get<AdminToolsCubit>(),
      )
      ..registerLazySingleton<SystemStatusCubit>(
        () => SystemStatusCubit(get<SystemStatusRepository>()),
      )
      ..registerLazySingleton<SessionCubit>(
        () {
          return SessionCubit(
            get<UserService>(),
            get<RegistrationService>(),
            get<RegistrationProgressNotifier>(),
            get<AccessControl>(),
            get<AdminTools>(),
            get<FeatureFlagsService>(),
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
          get<FeatureFlagsService>(),
        ),
      )
      ..registerLazySingleton<VotingCubit>(
        () => VotingCubit(
          get<UserService>(),
          get<CampaignService>(),
          get<ProposalService>(),
          get<VotingBallotBuilder>(),
          get<VotingService>(),
        ),
      )
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
          get<FeatureFlagsService>(),
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
          get<VotingBallotBuilder>(),
          get<VotingService>(),
          get<FeatureFlagsService>(),
        );
      })
      ..registerFactory<NewProposalCubit>(() {
        return NewProposalCubit(
          get<CampaignService>(),
          get<ProposalService>(),
          get<DocumentMapper>(),
        );
      })
      ..registerFactory<DevToolsBloc>(() {
        return DevToolsBloc(
          get<DevToolsService>(),
          get<SyncManager>(),
          isRegistered<LoggingService>() ? get<LoggingService>() : null,
          get<DownloaderService>(),
          get<DocumentsService>(),
        );
      })
      ..registerFactory<DocumentLookupBloc>(() {
        return DocumentLookupBloc(
          get<DocumentsService>(),
          get<DocumentMapper>(),
        );
      })
      ..registerFactory<CampaignPhaseAwareCubit>(() {
        return CampaignPhaseAwareCubit(
          get<CampaignService>(),
          get<SyncManager>(),
        );
      })
      ..registerFactory<VotingBallotBloc>(() {
        return VotingBallotBloc(
          get<UserService>(),
          get<CampaignService>(),
          get<VotingBallotBuilder>(),
          get<VotingService>(),
        );
      })
      ..registerFactory<FeatureFlagsCubit>(() {
        return FeatureFlagsCubit(
          get<FeatureFlagsService>(),
        );
      });
  }

  void _registerNetwork() {
    registerLazySingleton<ApiServices>(
      () {
        return ApiServices.dio(
          env: get<AppEnvironment>().type,
          authTokenProvider: get<AuthTokenProvider>(),
          interceptClient: get<ReportingService>().registerDio,
        );
      },
      dispose: (api) => api.dispose(),
    );
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
        return const SignedDocumentManager(
          brotli: CatalystBrotliCompressor(),
          zstd: CatalystZstdCompressor(),
        );
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
      )
      ..registerLazySingleton<DevToolsRepository>(
        () {
          return DevToolsRepository(
            get<DevToolsStorage>(),
          );
        },
      )
      ..registerLazySingleton<VotingRepository>(
        () => VotingRepository(
          get<CastedVotesObserver>(),
        ),
      )
      ..registerLazySingleton<SystemStatusRepository>(
        () => SystemStatusRepository(
          get<ApiServices>(),
        ),
      )
      ..registerLazySingleton<FeatureFlagsRepository>(
        () => FeatureFlagsRepository(
          get<AppEnvironment>().type,
          get<AppConfig>(),
        ),
      );
  }

  void _registerServices() {
    registerLazySingleton<CatalystKeyDerivation>(CatalystKeyDerivation.new);
    registerLazySingleton<KeyDerivationService>(() {
      return KeyDerivationService(get<CatalystKeyDerivation>());
    });
    registerLazySingleton<KeychainSigner>(() {
      return KeychainSignerService(get<KeyDerivationService>());
    });
    registerLazySingleton<KeychainProvider>(() {
      return VaultKeychainProvider(
        secureStorage: get<FlutterSecureStorage>(),
        sharedPreferences: get<SharedPreferencesAsync>(),
        cacheConfig: get<AppConfig>().cache,
        keychainSigner: get<KeychainSigner>(),
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
    registerLazySingleton<UploaderService>(UploaderService.new);
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
          get<RegistrationStatusPoller>(),
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
      );
    });
    registerLazySingleton<AccessControl>(AccessControl.new);
    registerLazySingleton<CampaignService>(() {
      return CampaignService(
        get<CampaignRepository>(),
        get<ProposalRepository>(),
        get<ActiveCampaignObserver>(),
      );
    });
    registerLazySingleton<ProposalService>(() {
      return ProposalService(
        get<ProposalRepository>(),
        get<DocumentRepository>(),
        get<UserService>(),
        get<SignerService>(),
        get<ActiveCampaignObserver>(),
        get<CastedVotesObserver>(),
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
    registerLazySingleton<DevToolsService>(() {
      return DevToolsService(
        get<DevToolsRepository>(),
        get<SyncStatsStorage>(),
        get<AppEnvironment>(),
        get<AppConfig>(),
      );
    });
    registerLazySingleton<ResourceUrlResolver>(() {
      return ResourceUrlResolver(environment: get<AppEnvironment>());
    });
    registerLazySingleton<ShareService>(() {
      return ShareService(
        get<ResourceUrlResolver>(),
        get<ResourceUrlResolver>(),
      );
    });
    registerLazySingleton<VotingService>(() {
      return VotingService(
        get<VotingRepository>(),
        get<ProposalService>(),
        get<CampaignService>(),
      );
    });
    registerLazySingleton<ReportingServiceMediator>(
      () {
        return ReportingServiceMediator(
          get<ReportingService>(),
          get<UserService>(),
        );
      },
      dispose: (mediator) => mediator.dispose(),
    );
    registerLazySingleton<FeatureFlagsService>(
      () {
        return FeatureFlagsService(
          get<FeatureFlagsRepository>(),
        );
      },
      dispose: (service) => unawaited(service.dispose()),
    );
  }

  void _registerStorages() {
    registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    registerLazySingleton<SharedPreferencesAsync>(SharedPreferencesAsync.new);
    registerLazySingleton<UserStorage>(SecureUserStorage.new);
    registerLazySingleton<CatalystDatabase>(
      () {
        final config = get<AppConfig>().database;
        final reporting = get<ReportingService>();

        return CatalystDatabase.drift(
          config: CatalystDriftDatabaseConfig(
            name: config.name,
            web: CatalystDriftDatabaseWebConfig(
              sqlite3Wasm: Uri.parse(config.webSqlite3Wasm),
              driftWorker: Uri.parse(config.webDriftWorker),
            ),
            native: CatalystDriftDatabaseNativeConfig(
              dbDir: () => path.getApplicationDocumentsDirectory().then((dir) => dir.path),
              dbTempDir: () => path.getTemporaryDirectory().then((dir) => dir.path),
            ),
          ),
          interceptor: reporting.buildDbInterceptor(databaseName: config.name),
        );
      },
      dispose: (database) async => database.close(),
    );
    registerLazySingleton<AuthTokenCache>(() {
      return LocalAuthTokenCache(
        sharedPreferences: get<SharedPreferencesAsync>(),
      );
    });
    registerLazySingleton<DevToolsStorage>(() {
      return DevToolsStorageLocal(
        sharedPreferences: get<SharedPreferencesAsync>(),
      );
    });
    registerLazySingleton<SyncStatsStorage>(
      () {
        return SyncStatsLocalStorage(
          sharedPreferences: get<SharedPreferencesAsync>(),
        );
      },
      dispose: (storage) async => storage.dispose(),
    );
    registerLazySingleton<AppMetaStorage>(
      () {
        return AppMetaStorageLocalStorage(
          sharedPreferences: get<SharedPreferencesAsync>(),
        );
      },
    );
  }

  void _registerUtils() {
    registerLazySingleton<SyncManager>(
      () {
        return SyncManager(
          get<AppMetaStorage>(),
          get<SyncStatsStorage>(),
          get<DocumentsService>(),
          get<CampaignService>(),
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
        return VideoManager(
          get<CatalystStartupProfiler>(),
        );
      },
      dispose: (manager) => manager.dispose(),
    );
    registerLazySingleton<ShareManager>(() => DelegatingShareManager(get<ShareService>()));
    registerLazySingleton<ActiveCampaignObserver>(
      ActiveCampaignObserverImpl.new,
      dispose: (observer) async => observer.dispose(),
    );
    registerLazySingleton<CastedVotesObserver>(CastedVotesObserverImpl.new);
    registerLazySingleton<VotingBallotBuilder>(VotingBallotLocalBuilder.new);

    // Not a singleton
    registerFactory<RegistrationStatusPoller>(
      () => RegistrationStatusPoller(get<UserRepository>()),
    );
    registerLazySingleton<DeviceInfoPlugin>(DeviceInfoPlugin.new);
    registerLazySingleton<PermissionHandler>(
      () => PermissionHandlerImpl(
        get<DeviceInfoPlugin>(),
      ),
    );
  }
}
