import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_reference.g.dart';

/// A Reference to another Signed Document
@JsonSerializable()
final class DocumentReference {
  /// Signed Document ID
  /// Document ID Reference
  final String id;

  /// Signed Document Version
  /// Document Version
  final String ver;

  const DocumentReference({
    required this.id,
    required this.ver,
  });

  factory DocumentReference.fromJson(Json json) => _$DocumentReferenceFromJson(json);

  Json toJson() => _$DocumentReferenceToJson(this);
}
