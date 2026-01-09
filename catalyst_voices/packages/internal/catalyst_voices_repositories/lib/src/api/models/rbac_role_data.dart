import 'package:catalyst_voices_repositories/src/api/models/extended_data.dart';
import 'package:catalyst_voices_repositories/src/api/models/key_data.dart';
import 'package:catalyst_voices_repositories/src/api/models/payment_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rbac_role_data.g.dart';

/// A RBAC registration role data.
@JsonSerializable()
final class RbacRoleData {
  /// A Catalyst user role identifier.
  @JsonKey(name: 'role_id')
  final int roleId;

  /// A list of role signing keys.
  @JsonKey(name: 'signing_keys')
  final List<KeyData> signingKeys;

  /// A list of role encryption keys.
  @JsonKey(name: 'encryption_keys')
  final List<KeyData>? encryptionKeys;

  /// A list of role payment addresses.
  @JsonKey(name: 'payment_addresses')
  final List<PaymentData> paymentAddresses;

  /// A map of the extended data.
  /// Unlike other fields, we don't track history for this data.
  @JsonKey(name: 'extended_data')
  final List<ExtendedData>? extendedData;

  const RbacRoleData({
    required this.roleId,
    required this.signingKeys,
    required this.paymentAddresses,
    this.encryptionKeys = const [],
    this.extendedData = const [],
  });

  factory RbacRoleData.fromJson(Map<String, dynamic> json) => _$RbacRoleDataFromJson(json);

  Map<String, dynamic> toJson() => _$RbacRoleDataToJson(this);
}
