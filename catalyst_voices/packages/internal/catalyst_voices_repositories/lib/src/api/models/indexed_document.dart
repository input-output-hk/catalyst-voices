import 'package:catalyst_voices_repositories/src/api/models/indexed_document_version.dart';
import 'package:json_annotation/json_annotation.dart';

part 'indexed_document.g.dart';

/// List of Documents that matched the filter
@JsonSerializable()
final class IndexedDocument {
  /// Signed Document ID
  /// Document ID that matches the filter
  final String id;

  /// List of matching versions of the document.
  /// Versions are listed in ascending order.
  final List<IndexedDocumentVersion> ver;

  IndexedDocument({
    required this.id,
    required this.ver,
  });

  factory IndexedDocument.fromJson(Map<String, dynamic> json) => _$IndexedDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$IndexedDocumentToJson(this);
}
