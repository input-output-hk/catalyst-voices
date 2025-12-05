import 'package:json_annotation/json_annotation.dart';

part 'document_reference.g.dart';

/// A Reference to another Signed Document
@JsonSerializable()
final class DocumentReference {
  /// Signed Document ID
  final String id;

  /// Signed Document Version
  final String ver;

  /// Signed Document Locator
  final String? cid;

  const DocumentReference({
    required this.id,
    required this.ver,
    this.cid,
  });

  factory DocumentReference.fromJson(Map<String, dynamic> json) =>
      _$DocumentReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentReferenceToJson(this);
}
