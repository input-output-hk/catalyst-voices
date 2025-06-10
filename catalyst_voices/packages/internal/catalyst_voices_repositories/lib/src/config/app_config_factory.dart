import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:collection/collection.dart';

final class AppConfigFactory {
  const AppConfigFactory._();

  static AppConfig build(
    RemoteConfig remote, {
    required AppEnvironmentType env,
  }) {
    final defaultEnvConfig = AppConfig.env(env);

    final remoteBlockchainConfig = remote.blockchain;
    final blockchain = defaultEnvConfig.blockchain;
    final transactionBuilderConfig = blockchain.transactionBuilderConfig;

    // Fee Algo
    final remoteFeeAlgo = remote.blockchain?.transactionBuilderConfig?.feeAlgo;
    final feeAlgo = transactionBuilderConfig.feeAlgo;
    final effectiveFeeAlgo = feeAlgo.copyWith(
      constant: remoteFeeAlgo?.constant,
      coefficient: remoteFeeAlgo?.coefficient,
      multiplier: remoteFeeAlgo?.multiplier,
      sizeIncrement: remoteFeeAlgo?.sizeIncrement,
      refScriptByteCost: remoteFeeAlgo?.refScriptByteCost,
      maxRefScriptSize: remoteFeeAlgo?.maxRefScriptSize,
    );

    // Transaction Builder Config
    final remoteTransactionBuilderConfig = remoteBlockchainConfig?.transactionBuilderConfig;
    final effectiveTransactionBuilderConfig = transactionBuilderConfig.copyWith(
      feeAlgo: effectiveFeeAlgo,
      maxTxSize: remoteTransactionBuilderConfig?.maxTxSize,
      maxValueSize: remoteTransactionBuilderConfig?.maxValueSize,
      maxAssetsPerOutput: remoteTransactionBuilderConfig?.maxAssetsPerOutput,
      coinsPerUtxoByte: remoteTransactionBuilderConfig?.coinsPerUtxoByte?.asCoin(),
      selectionStrategy: remoteTransactionBuilderConfig?.selectionStrategy?.build(),
    );

    // Slot Number Config
    final remoteSlotNumberConfig = remoteBlockchainConfig?.slotNumberConfig;
    final effectiveSlotNumberConfig = blockchain.slotNumberConfig.copyWith(
      systemStartTimestamp: remoteSlotNumberConfig?.systemStartTimestamp,
      systemStartSlot: remoteSlotNumberConfig?.systemStartSlot?.asSlotBigNum(),
      slotLength: remoteSlotNumberConfig?.slotLength?.asDuration(),
    );

    return defaultEnvConfig.copyWith(
      version: remote.version,
      cache: defaultEnvConfig.cache.copyWith(
        expiryDuration: defaultEnvConfig.cache.expiryDuration.copyWith(
          keychainUnlock: remote.cache?.expiryDuration?.keychainUnlock?.asDuration(),
        ),
      ),
      sentry: defaultEnvConfig.sentry.copyWith(
        dsn: remote.sentry?.dsn,
        environment: remote.sentry?.environment,
        release: remote.sentry?.release,
        tracesSampleRate: remote.sentry?.tracesSampleRate,
        profilesSampleRate: remote.sentry?.profilesSampleRate,
        enableAutoSessionTracking: remote.sentry?.enableAutoSessionTracking,
        attachScreenshot: remote.sentry?.attachScreenshot,
        attachViewHierarchy: remote.sentry?.attachViewHierarchy,
        debug: remote.sentry?.debug,
        diagnosticLevel: remote.sentry?.diagnosticLevel,
      ),
      blockchain: defaultEnvConfig.blockchain.copyWith(
        networkId: remoteBlockchainConfig?.networkId?.tryParseNetworkId(),
        host: remoteBlockchainConfig?.host?.tryParseCatalystIdHost(),
        transactionBuilderConfig: effectiveTransactionBuilderConfig,
        slotNumberConfig: effectiveSlotNumberConfig,
      ),
    );
  }
}

extension on String {
  CatalystIdHost? tryParseCatalystIdHost() {
    return CatalystIdHost.values.firstWhereOrNull((e) => e.host == this);
  }

  NetworkId? tryParseNetworkId() => NetworkId.values.asNameMap()[this];
}

extension on int {
  Coin asCoin() => Coin(this);

  Duration asDuration() => Duration(seconds: this);

  SlotBigNum asSlotBigNum() => SlotBigNum(this);
}

extension on RemoteTransactionSelectionStrategyType {
  CoinSelectionStrategy build() {
    return switch (this) {
      RemoteTransactionSelectionStrategyType.greedy => const GreedySelectionStrategy(),
      RemoteTransactionSelectionStrategyType.exactBiggest =>
        const ExactBiggestAssetSelectionStrategy(),
      RemoteTransactionSelectionStrategyType.random => RandomSelectionStrategy(),
    };
  }
}
