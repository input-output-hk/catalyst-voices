import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_status.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_rbac_registration_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'catalyst_id_public.g.dart';

/// Model for the CatalystID to expose publicly.
///
/// Used as response for:
/// - GET /api/catalyst-ids/me
/// - POST /api/catalyst-ids/me
@JsonSerializable()
final class CatalystIdPublic {
  /// The catalyst ID.
  @JsonKey(name: '_cid')
  final String? cid;

  /// The email address.
  final String? email;

  /// The username.
  final String? username;

  /// The status of the catalyst ID.
  final CatalystIdStatus status;

  /// The RBAC registration status.
  @JsonKey(name: 'rbac_reg_status')
  final CatalystRbacRegistrationStatus rbacRegStatus;

  const CatalystIdPublic({
    this.cid,
    this.email,
    this.username,
    this.status = CatalystIdStatus.inactive,
    this.rbacRegStatus = CatalystRbacRegistrationStatus.initialized,
  });

  factory CatalystIdPublic.fromJson(Map<String, dynamic> json) => _$CatalystIdPublicFromJson(json);

  Map<String, dynamic> toJson() => _$CatalystIdPublicToJson(this);
}
