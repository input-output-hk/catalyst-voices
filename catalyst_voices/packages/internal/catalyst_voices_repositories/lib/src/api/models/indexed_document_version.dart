import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
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

  /// Document Reference that matches the filter
  /// Max items 10
  final List<DocumentReference>? ref;

  /// DDocument Reply Reference that matches the filter
  /// Max items 10
  final List<DocumentReference>? reply;

  /// Document Template Reference that matches the filter
  /// Max items 10
  final List<DocumentReference>? template;

  /// Document Parameter Reference that matches the filter
  /// Max items 10
  @JsonKey(name: 'doc_parameters')
  final List<DocumentReference>? parameters;

  IndexedDocumentVersion({
    required this.ver,
    required this.type,
    this.ref,
    this.reply,
    this.template,
    this.parameters,
  });

  factory IndexedDocumentVersion.fromJson(Map<String, dynamic> json) =>
      _$IndexedDocumentVersionFromJson(json);

  Map<String, dynamic> toJson() => _$IndexedDocumentVersionToJson(this);
}
