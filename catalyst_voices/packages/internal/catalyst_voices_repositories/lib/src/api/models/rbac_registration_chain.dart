import 'package:catalyst_voices_repositories/src/api/models/invalid_registration.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_role_data.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_stake_address_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rbac_registration_chain.g.dart';

/// A chain of valid RBAC registrations.
/// A unified data of multiple RBAC registrations.
///
/// Used as response for GET /api/v2/rbac/registration
@JsonSerializable()
final class RbacRegistrationChain {
  /// Catalyst ID
  @JsonKey(name: 'catalyst_id')
  final String catalystId;

  /// Transaction Id/Hash
  /// An ID of the last persistent transaction.
  @JsonKey(name: 'last_persistent_txn')
  final String? lastPersistentTxn;

  /// Transaction Id/Hash
  /// An ID of the last volatile transaction.
  @JsonKey(name: 'last_volatile_txn')
  final String? lastVolatileTxn;

  /// A list of registration purposes.
  /// 128 Bit UUID Version 4 - Random
  final List<String> purpose;

  /// A list of role data.
  final List<RbacRoleData> roles;

  /// A list of invalid registrations.
  final List<InvalidRegistration>? invalid;

  /// A list of stake addresses of the chain.
  @JsonKey(name: 'stake_addresses')
  final List<RbacStakeAddressInfo>? stakeAddresses;

  const RbacRegistrationChain({
    required this.catalystId,
    this.lastPersistentTxn,
    this.lastVolatileTxn,
    this.purpose = const [],
    this.roles = const [],
    this.invalid = const [],
    this.stakeAddresses = const [],
  });

  factory RbacRegistrationChain.fromJson(Map<String, dynamic> json) =>
      _$RbacRegistrationChainFromJson(json);

  Map<String, dynamic> toJson() => _$RbacRegistrationChainToJson(this);
}
