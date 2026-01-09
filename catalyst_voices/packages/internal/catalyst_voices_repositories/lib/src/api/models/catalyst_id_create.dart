import 'package:json_annotation/json_annotation.dart';

part 'catalyst_id_create.g.dart';

/// Model for the creation and the update of the email in DB.
///
/// Used as request body for POST /api/catalyst-ids/me
@JsonSerializable()
final class CatalystIdCreate {
  /// The email address.
  final String email;

  /// The catalyst Id Uri.
  @JsonKey(name: 'catalyst_id_uri')
  final String catalystIdUri;

  const CatalystIdCreate({
    required this.email,
    required this.catalystIdUri,
  });

  factory CatalystIdCreate.fromJson(Map<String, dynamic> json) => _$CatalystIdCreateFromJson(json);

  Map<String, dynamic> toJson() => _$CatalystIdCreateToJson(this);
}
