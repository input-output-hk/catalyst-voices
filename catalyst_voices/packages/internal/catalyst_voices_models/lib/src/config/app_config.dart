import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const _defaultTransactionBuilderConfig = TransactionBuilderConfig(
  feeAlgo: TieredFee(
    constant: 155381,
    coefficient: 44,
    refScriptByteCost: 15,
  ),
  maxTxSize: 16384,
  maxValueSize: 5000,
  maxAssetsPerOutput: 100,
  coinsPerUtxoByte: Coin(4310),
  selectionStrategy: ExactBiggestAssetSelectionStrategy(),
);

/// A comprehensive configuration class for the application.
///
/// It encapsulates all environment-specific settings, including versioning,
/// caching, database, error tracking (Sentry), and blockchain configurations.
/// Named constructors are provided for different environments ([AppEnvironmentType]).
final class AppConfig extends Equatable {
  final String version;
  final CacheConfig cache;
  final DatabaseConfig database;
  final SentryConfig sentry;
  final BlockchainConfig blockchain;
  final StressTestConfig stressTest;
  final CatalystDeveloperProfilerConfig profiler;

  const AppConfig({
    required this.version,
    required this.cache,
    required this.database,
    required this.sentry,
    required this.blockchain,
    required this.stressTest,
    required this.profiler,
  });

  AppConfig.dev()
    : this(
        version: '0.0.1',
        cache: const CacheConfig(
          expiryDuration: ExpiryDuration(
            keychainUnlock: Duration(hours: 1),
          ),
        ),
        database: const DatabaseConfig(),
        sentry: const SentryConfig(
          dsn:
              'https://8e333ddbed1e096c70e4ed006892c355@o622089.ingest.us.sentry.io/4507113601433600',
          environment: 'dev',
          tracesSampleRate: 1,
          profilesSampleRate: 1,
          enableAutoSessionTracking: true,
          enableTimeToFullDisplayTracing: true,
          enableLogs: true,
          attachScreenshot: true,
          attachViewHierarchy: true,
          diagnosticLevel: 'debug',
        ),
        blockchain: BlockchainConfig(
          networkId: NetworkId.testnet,
          host: CatalystIdHost.cardanoPreprod,
          transactionBuilderConfig: _defaultTransactionBuilderConfig,
          slotNumberConfig: BlockchainSlotNumberConfig.testnet(),
        ),
        stressTest: const StressTestConfig(),
        profiler: const CatalystDeveloperProfilerConfig(),
      );

  factory AppConfig.env(AppEnvironmentType env) {
    return switch (env) {
      AppEnvironmentType.dev => AppConfig.dev(),
      AppEnvironmentType.preprod => AppConfig.preprod(),
      AppEnvironmentType.prod => AppConfig.prod(),
      AppEnvironmentType.relative => AppConfig.dev(),
    };
  }

  AppConfig.preprod()
    : this(
        version: '0.0.1',
        cache: const CacheConfig(
          expiryDuration: ExpiryDuration(
            keychainUnlock: Duration(hours: 1),
          ),
        ),
        database: const DatabaseConfig(),
        sentry: const SentryConfig(
          dsn:
              'https://8e333ddbed1e096c70e4ed006892c355@o622089.ingest.us.sentry.io/4507113601433600',
          environment: 'preprod',
          tracesSampleRate: 0.2,
          profilesSampleRate: 0.2,
          enableAutoSessionTracking: true,
          enableTimeToFullDisplayTracing: true,
          enableLogs: true,
          attachScreenshot: false,
          attachViewHierarchy: true,
          diagnosticLevel: 'warning',
        ),
        blockchain: BlockchainConfig(
          networkId: NetworkId.testnet,
          host: CatalystIdHost.cardanoPreprod,
          transactionBuilderConfig: _defaultTransactionBuilderConfig,
          slotNumberConfig: BlockchainSlotNumberConfig.testnet(),
        ),
        stressTest: const StressTestConfig(),
        profiler: const CatalystDeveloperProfilerConfig(),
      );

  AppConfig.prod()
    : this(
        version: '0.0.1',
        cache: const CacheConfig(
          expiryDuration: ExpiryDuration(
            keychainUnlock: Duration(hours: 1),
          ),
        ),
        database: const DatabaseConfig(),
        sentry: const SentryConfig(
          dsn:
              'https://8e333ddbed1e096c70e4ed006892c355@o622089.ingest.us.sentry.io/4507113601433600',
          environment: 'prod',
          tracesSampleRate: 0.1,
          profilesSampleRate: 0.1,
          enableAutoSessionTracking: true,
          enableTimeToFullDisplayTracing: true,
          enableLogs: false,
          attachScreenshot: false,
          attachViewHierarchy: false,
          diagnosticLevel: 'error',
        ),
        blockchain: BlockchainConfig(
          networkId: NetworkId.mainnet,
          host: CatalystIdHost.cardano,
          transactionBuilderConfig: _defaultTransactionBuilderConfig,
          slotNumberConfig: BlockchainSlotNumberConfig.mainnet(),
        ),
        stressTest: const StressTestConfig(),
        profiler: const CatalystDeveloperProfilerConfig(),
      );

  @override
  List<Object?> get props => [
    version,
    cache,
    database,
    sentry,
    blockchain,
    stressTest,
    profiler,
  ];

  AppConfig copyWith({
    String? version,
    CacheConfig? cache,
    DatabaseConfig? database,
    SentryConfig? sentry,
    BlockchainConfig? blockchain,
    StressTestConfig? stressTest,
    CatalystDeveloperProfilerConfig? profiler,
  }) {
    return AppConfig(
      version: version ?? this.version,
      cache: cache ?? this.cache,
      database: database ?? this.database,
      sentry: sentry ?? this.sentry,
      blockchain: blockchain ?? this.blockchain,
      stressTest: stressTest ?? this.stressTest,
      profiler: profiler ?? this.profiler,
    );
  }
}

final class BlockchainConfig extends Equatable {
  final NetworkId networkId;
  final CatalystIdHost host;
  final TransactionBuilderConfig transactionBuilderConfig;
  final BlockchainSlotNumberConfig slotNumberConfig;

  const BlockchainConfig({
    required this.networkId,
    required this.host,
    required this.transactionBuilderConfig,
    required this.slotNumberConfig,
  });

  @override
  List<Object?> get props => [
    networkId,
    host,
    transactionBuilderConfig,
    slotNumberConfig,
  ];

  BlockchainConfig copyWith({
    NetworkId? networkId,
    CatalystIdHost? host,
    TransactionBuilderConfig? transactionBuilderConfig,
    BlockchainSlotNumberConfig? slotNumberConfig,
  }) {
    return BlockchainConfig(
      networkId: networkId ?? this.networkId,
      host: host ?? this.host,
      transactionBuilderConfig: transactionBuilderConfig ?? this.transactionBuilderConfig,
      slotNumberConfig: slotNumberConfig ?? this.slotNumberConfig,
    );
  }
}

final class CacheConfig extends Equatable {
  final ExpiryDuration expiryDuration;

  const CacheConfig({
    required this.expiryDuration,
  });

  @override
  List<Object?> get props => [expiryDuration];

  CacheConfig copyWith({
    ExpiryDuration? expiryDuration,
  }) {
    return CacheConfig(
      expiryDuration: expiryDuration ?? this.expiryDuration,
    );
  }
}

/// Database configuration for the application.
///
/// IMPORTANT: Web asset versioning notes:
/// - [webSqlite3Wasm] and [webDriftWorker] files require manual versioning
/// - These filenames are hardcoded here and compiled into the app during build
/// - The automatic versioning script runs AFTER `flutter build web`, so it cannot
///   update these hardcoded references
/// - When these files change, manually rename them with a version suffix
///   (e.g., 'sqlite3.v2.wasm') and update the filenames here BEFORE building
final class DatabaseConfig extends Equatable {
  final String name;
  final String webSqlite3Wasm;
  final String webDriftWorker;

  const DatabaseConfig({
    this.name = 'catalyst_db',
    this.webSqlite3Wasm = 'sqlite3.v1.wasm',
    this.webDriftWorker = 'drift_worker.v1.js',
  });

  @override
  List<Object?> get props => [
    name,
    webSqlite3Wasm,
    webDriftWorker,
  ];
}

final class ExpiryDuration extends Equatable {
  final Duration keychainUnlock;

  const ExpiryDuration({
    required this.keychainUnlock,
  });

  @override
  List<Object?> get props => [keychainUnlock];

  ExpiryDuration copyWith({
    Duration? keychainUnlock,
  }) {
    return ExpiryDuration(
      keychainUnlock: keychainUnlock ?? this.keychainUnlock,
    );
  }
}

final class SentryConfig extends ReportingServiceConfig {
  final String dsn;
  final String environment;
  final double tracesSampleRate;
  final double profilesSampleRate;
  final bool enableAutoSessionTracking;
  final bool enableTimeToFullDisplayTracing;
  final bool enableLogs;
  final bool attachScreenshot;
  final bool attachViewHierarchy;
  final String diagnosticLevel;

  const SentryConfig({
    required this.dsn,
    required this.environment,
    required this.tracesSampleRate,
    required this.profilesSampleRate,
    required this.enableAutoSessionTracking,
    required this.enableTimeToFullDisplayTracing,
    required this.enableLogs,
    required this.attachScreenshot,
    required this.attachViewHierarchy,
    required this.diagnosticLevel,
  });

  bool get debug => kDebugMode;

  String? get dist {
    const key = 'SENTRY_DIST';
    return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;
  }

  @override
  List<Object?> get props => [
    dsn,
    environment,
    tracesSampleRate,
    profilesSampleRate,
    enableAutoSessionTracking,
    enableTimeToFullDisplayTracing,
    enableLogs,
    attachScreenshot,
    attachViewHierarchy,
    diagnosticLevel,
  ];

  String? get release {
    const key = 'SENTRY_RELEASE';
    return const bool.hasEnvironment(key) ? const String.fromEnvironment(key) : null;
  }

  SentryConfig copyWith({
    String? dsn,
    String? environment,
    double? tracesSampleRate,
    double? profilesSampleRate,
    bool? enableAutoSessionTracking,
    bool? enableTimeToFullDisplayTracing,
    bool? enableLogs,
    bool? attachViewHierarchy,
    String? diagnosticLevel,
  }) {
    return SentryConfig(
      dsn: dsn ?? this.dsn,
      environment: environment ?? this.environment,
      tracesSampleRate: tracesSampleRate ?? this.tracesSampleRate,
      profilesSampleRate: profilesSampleRate ?? this.profilesSampleRate,
      enableAutoSessionTracking: enableAutoSessionTracking ?? this.enableAutoSessionTracking,
      enableTimeToFullDisplayTracing:
          enableTimeToFullDisplayTracing ?? this.enableTimeToFullDisplayTracing,
      enableLogs: enableLogs ?? this.enableLogs,
      attachScreenshot: attachScreenshot,
      attachViewHierarchy: attachViewHierarchy ?? this.attachViewHierarchy,
      diagnosticLevel: diagnosticLevel ?? this.diagnosticLevel,
    );
  }
}

final class StressTestConfig extends Equatable {
  const StressTestConfig();

  bool get clearDatabase => const bool.fromEnvironment('STRESS_TEST_CLEAR_DB');

  bool get decompressedDocuments => const bool.fromEnvironment('STRESS_TEST_DECOMPRESSED');

  int get indexedProposalsCount {
    return const int.fromEnvironment(
      'STRESS_TEST_PROPOSAL_INDEX_COUNT',
      defaultValue: 100,
    );
  }

  bool get isEnabled => const bool.fromEnvironment('STRESS_TEST');

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'StressTestConfig('
        'isEnabled[$isEnabled], '
        'indexedProposalsCount[$indexedProposalsCount], '
        'decompressedDocuments[$decompressedDocuments], '
        'clearDatabase[$clearDatabase]'
        ')';
  }
}
