import 'package:json_annotation/json_annotation.dart';

part 'remote_blockchain_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteBlockchainConfig {
  final String? networkId;
  final String? host;
  final RemoteTransactionBuilderConfig? transactionBuilderConfig;
  final RemoteSlotNumberConfig? slotNumberConfig;

  RemoteBlockchainConfig({
    this.networkId,
    this.host,
    this.transactionBuilderConfig,
    this.slotNumberConfig,
  });

  factory RemoteBlockchainConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteBlockchainConfigFromJson(json);
  }
}

@JsonSerializable(createToJson: false)
final class RemoteSlotNumberConfig {
  final DateTime? systemStartTimestamp;
  final int? systemStartSlot;
  final int? slotLength;

  RemoteSlotNumberConfig({
    this.systemStartTimestamp,
    this.systemStartSlot,
    this.slotLength,
  });

  factory RemoteSlotNumberConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteSlotNumberConfigFromJson(json);
  }
}

@JsonSerializable(createToJson: false)
final class RemoteTransactionBuilderConfig {
  final RemoteTransactionTieredFee? feeAlgo;
  final int? maxTxSize;
  final int? maxValueSize;
  final int? maxAssetsPerOutput;
  final int? coinsPerUtxoByte;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final RemoteTransactionSelectionStrategyType? selectionStrategy;

  const RemoteTransactionBuilderConfig({
    this.feeAlgo,
    this.maxTxSize,
    this.maxValueSize,
    this.maxAssetsPerOutput,
    this.coinsPerUtxoByte,
    this.selectionStrategy,
  });

  factory RemoteTransactionBuilderConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteTransactionBuilderConfigFromJson(json);
  }
}

enum RemoteTransactionSelectionStrategyType { greedy, exactBiggest, random }

@JsonSerializable(createToJson: false)
final class RemoteTransactionTieredFee {
  final int? constant;
  final int? coefficient;
  final double? multiplier;
  final int? sizeIncrement;
  final int? refScriptByteCost;
  final int? maxRefScriptSize;

  const RemoteTransactionTieredFee({
    this.constant,
    this.coefficient,
    this.multiplier,
    this.sizeIncrement,
    this.refScriptByteCost,
    this.maxRefScriptSize,
  });

  factory RemoteTransactionTieredFee.fromJson(Map<String, dynamic> json) {
    return _$RemoteTransactionTieredFeeFromJson(json);
  }
}
