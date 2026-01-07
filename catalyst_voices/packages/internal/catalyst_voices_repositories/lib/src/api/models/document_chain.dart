import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_chain.g.dart';

/// A reference to the previous signed document in a sequence.
@JsonSerializable()
final class DocumentChain {
  /// A document height
  /// A consecutive sequence number of the current document in the chain.
  final int height;

  /// Document Reference for filtered Documents.
  /// A reference to a single signed document.
  @JsonKey(name: 'document_ref')
  final DocumentReference? documentRef;

  const DocumentChain({required this.height, this.documentRef});

  factory DocumentChain.fromJson(Map<String, dynamic> json) => _$DocumentChainFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentChainToJson(this);
}
