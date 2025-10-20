import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rbac_registration_chain.g.dart';

/// A chain of valid RBAC registrations.
/// A unified data of multiple RBAC registrations.
///
/// Used as response for GET /api/v1/rbac/registration
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

  /// RBAC role data map
  /// A map of role number to role data.
  final Json roles;

  const RbacRegistrationChain({
    required this.catalystId,
    this.lastPersistentTxn,
    this.lastVolatileTxn,
    this.purpose = const <String>[],
    this.roles = const <String, dynamic>{},
  });

  factory RbacRegistrationChain.fromJson(Json json) => _$RbacRegistrationChainFromJson(json);

  Json toJson() => _$RbacRegistrationChainToJson(this);
}
