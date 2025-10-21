import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/common/json.dart';
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
  /// Document Template Reference that matches the filter
  final DocumentReference? template;

  /// Document Reference for filtered Documents.
  /// Document Parameter Reference that matches the filter
  @JsonKey(name: 'doc_parameters')
  final DocumentReference? parameters;

  IndexedDocumentVersion({
    required this.ver,
    required this.type,
    this.ref,
    this.reply,
    this.template,
    this.parameters,
  });

  factory IndexedDocumentVersion.fromJson(Json json) => _$IndexedDocumentVersionFromJson(json);

  Json toJson() => _$IndexedDocumentVersionToJson(this);
}
