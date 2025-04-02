import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ApiConfig extends Equatable {
  final String gatewayUrl;
  final String vitUrl;
  final String reviewsUrl;

  const ApiConfig({
    this.gatewayUrl = 'https://gateway.dev.projectcatalyst.io/',
    this.vitUrl = 'https://core.dev.projectcatalyst.io/',
    this.reviewsUrl = 'https://api.reviews.dev.projectcatalyst.io/',
  });

  @override
  List<Object?> get props => [
        gatewayUrl,
        vitUrl,
        reviewsUrl,
      ];

  ApiConfig copyWith({
    String? gatewayUrl,
    String? vitUrl,
    String? reviewsUrl,
  }) {
    return ApiConfig(
      gatewayUrl: gatewayUrl ?? this.gatewayUrl,
      vitUrl: vitUrl ?? this.vitUrl,
      reviewsUrl: reviewsUrl ?? this.reviewsUrl,
    );
  }
}

final class AppConfig extends Equatable {
  final ApiConfig api;
  final CacheConfig cache;
  final DatabaseConfig database;
  final SentryConfig sentry;
  final BlockchainConfig blockchain;

  const AppConfig({
    this.api = const ApiConfig(),
    this.cache = const CacheConfig(),
    this.database = const DatabaseConfig(),
    this.sentry = const SentryConfig(),
    this.blockchain = const BlockchainConfig(),
  });

  const AppConfig.fallback() : this();

  factory AppConfig.env(AppEnvironmentType env) {
    // TODO(damian-molinski): build default config for each env.

    return AppConfig.fallback();
  }

  @override
  List<Object?> get props => [
        api,
        cache,
        database,
        sentry,
        blockchain,
      ];

  AppConfig copyWith({
    ApiConfig? api,
    CacheConfig? cache,
    DatabaseConfig? database,
    SentryConfig? sentry,
    BlockchainConfig? blockchain,
  }) {
    return AppConfig(
      api: api ?? this.api,
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

  const BlockchainConfig({
    this.networkId = NetworkId.testnet,
    this.host = CatalystIdHost.cardanoPreprod,
    this.transactionBuilderConfig = const TransactionBuilderConfig(
      feeAlgo: TieredFee(
        constant: 155381,
        coefficient: 44,
        refScriptByteCost: 15,
      ),
      maxTxSize: 16384,
      maxValueSize: 5000,
      coinsPerUtxoByte: Coin(4310),
    ),
  });

  @override
  List<Object?> get props => [networkId, host, transactionBuilderConfig];

  BlockchainConfig copyWith({
    NetworkId? networkId,
    CatalystIdHost? host,
    TransactionBuilderConfig? transactionBuilderConfig,
  }) {
    return BlockchainConfig(
      networkId: networkId ?? this.networkId,
      host: host ?? this.host,
      transactionBuilderConfig:
          transactionBuilderConfig ?? this.transactionBuilderConfig,
    );
  }
}

final class CacheConfig extends Equatable {
  final ExpiryDuration expiryDuration;

  const CacheConfig({
    this.expiryDuration = const ExpiryDuration(),
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
    this.keychainUnlock = const Duration(hours: 1),
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
  final String dns;
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
    this.dns = '',
    this.environment = 'catalyst-voices@dev',
    this.release = '1.0.0',
    this.tracesSampleRate = 1.0,
    this.profilesSampleRate = 1.0,
    this.enableAutoSessionTracking = true,
    this.attachScreenshot = true,
    this.attachViewHierarchy = true,
    this.debug = true,
    this.diagnosticLevel = 'debug',
  });

  @override
  List<Object?> get props => [
        dns,
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
    String? dns,
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
      dns: dns ?? this.dns,
      environment: environment ?? this.environment,
      release: release ?? this.release,
      tracesSampleRate: tracesSampleRate ?? this.tracesSampleRate,
      profilesSampleRate: profilesSampleRate ?? this.profilesSampleRate,
      enableAutoSessionTracking:
          enableAutoSessionTracking ?? this.enableAutoSessionTracking,
      attachScreenshot: attachScreenshot ?? this.attachScreenshot,
      attachViewHierarchy: attachViewHierarchy ?? this.attachViewHierarchy,
      debug: debug ?? this.debug,
      diagnosticLevel: diagnosticLevel ?? this.diagnosticLevel,
    );
  }
}
