import 'package:catalyst_voices_repositories/src/api/models/staked_txo_asset_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stake_info.g.dart';

/// User's cardano stake info.
@JsonSerializable()
final class StakeInfo {
  /// Cardano Blockchain ADA coins value
  /// Total stake amount.
  @JsonKey(name: 'ada_amount')
  final int adaAmount;

  /// Cardano Blockchain Slot Number
  /// Block's slot number which contains the latest unspent UTXO.
  @JsonKey(name: 'slot_number')
  final int slotNumber;

  /// TXO assets infos.
  final List<StakedTxoAssetInfo> assets;

  const StakeInfo({
    required this.adaAmount,
    required this.slotNumber,
    required this.assets,
  });

  factory StakeInfo.fromJson(Map<String, dynamic> json) => _$StakeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StakeInfoToJson(this);
}
