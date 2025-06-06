import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

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

final class AppConfig extends Equatable {
  final String version;
  final CacheConfig cache;
  final DatabaseConfig database;
  final SentryConfig sentry;
  final BlockchainConfig blockchain;

  const AppConfig({
    required this.version,
    required this.cache,
    required this.database,
    required this.sentry,
    required this.blockchain,
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
            release: 'catalyst-voices@dev',
            tracesSampleRate: 1,
            profilesSampleRate: 1,
            enableAutoSessionTracking: true,
            attachScreenshot: true,
            attachViewHierarchy: true,
            debug: true,
            diagnosticLevel: 'debug',
          ),
          blockchain: BlockchainConfig(
            networkId: NetworkId.testnet,
            host: CatalystIdHost.cardanoPreprod,
            transactionBuilderConfig: _defaultTransactionBuilderConfig,
            slotNumberConfig: BlockchainSlotNumberConfig.testnet(),
          ),
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
            release: 'catalyst-voices@preprod',
            tracesSampleRate: 0.2,
            profilesSampleRate: 0.2,
            enableAutoSessionTracking: true,
            attachScreenshot: true,
            attachViewHierarchy: true,
            debug: false,
            diagnosticLevel: 'warning',
          ),
          blockchain: BlockchainConfig(
            networkId: NetworkId.testnet,
            host: CatalystIdHost.cardanoPreprod,
            transactionBuilderConfig: _defaultTransactionBuilderConfig,
            slotNumberConfig: BlockchainSlotNumberConfig.testnet(),
          ),
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
            release: 'catalyst-voices@prod',
            tracesSampleRate: 0.1,
            profilesSampleRate: 0.1,
            enableAutoSessionTracking: true,
            attachScreenshot: false,
            attachViewHierarchy: false,
            debug: false,
            diagnosticLevel: 'error',
          ),
          blockchain: BlockchainConfig(
            networkId: NetworkId.mainnet,
            host: CatalystIdHost.cardano,
            transactionBuilderConfig: _defaultTransactionBuilderConfig,
            slotNumberConfig: BlockchainSlotNumberConfig.mainnet(),
          ),
        );

  @override
  List<Object?> get props => [
        version,
        cache,
        database,
        sentry,
        blockchain,
      ];

  AppConfig copyWith({
    String? version,
    CacheConfig? cache,
    DatabaseConfig? database,
    SentryConfig? sentry,
    BlockchainConfig? blockchain,
  }) {
    return AppConfig(
      version: version ?? this.version,
      cache: cache ?? this.cache,
      database: database ?? this.database,
      sentry: sentry ?? this.sentry,
      blockchain: blockchain ?? this.blockchain,
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

final class DatabaseConfig extends Equatable {
  final String name;
  final String webSqlite3Wasm;
  final String webDriftWorker;

  const DatabaseConfig({
    this.name = 'catalyst_db',
    this.webSqlite3Wasm = 'sqlite3.wasm',
    this.webDriftWorker = 'drift_worker.js',
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

final class SentryConfig extends Equatable {
  final String dsn;
  final String environment;
  final String release;
  final double tracesSampleRate;
  final double profilesSampleRate;
  final bool enableAutoSessionTracking;
  final bool attachScreenshot;
  final bool attachViewHierarchy;
  final bool debug;
  final String diagnosticLevel;

  const SentryConfig({
    required this.dsn,
    required this.environment,
    required this.release,
    required this.tracesSampleRate,
    required this.profilesSampleRate,
    required this.enableAutoSessionTracking,
    required this.attachScreenshot,
    required this.attachViewHierarchy,
    required this.debug,
    required this.diagnosticLevel,
  });

  @override
  List<Object?> get props => [
        dsn,
        environment,
        release,
        tracesSampleRate,
        profilesSampleRate,
        enableAutoSessionTracking,
        attachScreenshot,
        attachViewHierarchy,
        debug,
        diagnosticLevel,
      ];

  SentryConfig copyWith({
    String? dsn,
    String? environment,
    String? release,
    double? tracesSampleRate,
    double? profilesSampleRate,
    bool? enableAutoSessionTracking,
    bool? attachScreenshot,
    bool? attachViewHierarchy,
    bool? debug,
    String? diagnosticLevel,
  }) {
    return SentryConfig(
      dsn: dsn ?? this.dsn,
      environment: environment ?? this.environment,
      release: release ?? this.release,
      tracesSampleRate: tracesSampleRate ?? this.tracesSampleRate,
      profilesSampleRate: profilesSampleRate ?? this.profilesSampleRate,
      enableAutoSessionTracking: enableAutoSessionTracking ?? this.enableAutoSessionTracking,
      attachScreenshot: attachScreenshot ?? this.attachScreenshot,
      attachViewHierarchy: attachViewHierarchy ?? this.attachViewHierarchy,
      debug: debug ?? this.debug,
      diagnosticLevel: diagnosticLevel ?? this.diagnosticLevel,
    );
  }
}
