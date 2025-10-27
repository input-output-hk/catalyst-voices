import 'package:catalyst_voices_repositories/src/api/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_index_list.g.dart';

/// A single page of documents.
///
/// The page limit is defined by the number of document versions,
/// not the number of Document IDs.
@JsonSerializable()
class DocumentIndexList {
  /// List of documents that matched the filter.
  ///
  /// Documents are listed in ascending order.
  final List<IndexedDocument> docs;

  /// The Page of Document Index List.
  final CurrentPage page;

  const DocumentIndexList({
    required this.docs,
    required this.page,
  });

  factory DocumentIndexList.fromJson(Map<String, dynamic> json) =>
      _$DocumentIndexListFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentIndexListToJson(this);
}
