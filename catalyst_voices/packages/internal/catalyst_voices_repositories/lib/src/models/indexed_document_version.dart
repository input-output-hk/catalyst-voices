import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:catalyst_voices_repositories/src/models/document_reference.dart';
import 'package:json_annotation/json_annotation.dart';

part 'indexed_document_version.g.dart';

/// List of Documents that matched the filter
@JsonSerializable()
final class IndexedDocumentVersion {
  /// Signed Document Version
  /// Document Version that matches the filter
  final String ver;

  /// Signed Document Type
  /// Document Type that matches the filter
  final String type;

  /// Document Reference for filtered Documents.
  /// Document Reference that matches the filter
  final DocumentReference? ref;

  /// Document Reference for filtered Documents.
  /// DDocument Reply Reference that matches the filter
  final DocumentReference? reply;

  /// Document Reference for filtered Documents.
  /// Document Parameter Reference that matches the filter
  @JsonKey(name: 'doc_parameters')
  final DocumentReference? parameters;

  /// Document Reference for filtered Documents.
  /// Document Template Reference that matches the filter
  final DocumentReference? template;
  final DocumentReference? brand;
  final DocumentReference? campaign;
  final DocumentReference? category;

  IndexedDocumentVersion({
    required this.ver,
    required this.type,
    this.ref,
    this.reply,
    this.parameters,
    this.template,
    this.brand,
    this.campaign,
    this.category,
  });

  factory IndexedDocumentVersion.fromJson(Json json) => _$IndexedDocumentVersionFromJson(json);

  Json toJson() => _$IndexedDocumentVersionToJson(this);
}
