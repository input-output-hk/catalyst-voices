import 'package:json_annotation/json_annotation.dart';

part 'rbac_stake_address_info.g.dart';

/// An information about stake address used in a RBAC registration chain
@JsonSerializable()
final class RbacStakeAddressInfo {
  /// Cardano stake address
  final String stake;

  /// Cardano Blockchain Slot Number
  /// A slot number when the registration chain started to use the stake address.
  @JsonKey(name: 'active_from')
  final int activeFrom;

  /// Cardano Blockchain Slot Number
  /// A slot number when the registration chain stopped to use the stake address.
  @JsonKey(name: 'inactive_from')
  final int? inactiveFrom;

  const RbacStakeAddressInfo({
    required this.stake,
    required this.activeFrom,
    this.inactiveFrom,
  });

  factory RbacStakeAddressInfo.fromJson(Map<String, dynamic> json) =>
      _$RbacStakeAddressInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RbacStakeAddressInfoToJson(this);
}
