import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Represents raw data about any document. It may be published signed document
/// or local draft.
///
/// Context
/// Its different from [Document] which may require multiple [DocumentData].
/// For example one [Document] of [DocumentType.proposalDocument] require
/// document itself and template which is different document.
///
/// [DocumentData] can be created from [SignedDocument] which comes from
/// backend or locally as work in progress.
base class DocumentData extends Equatable implements Comparable<DocumentData> {
  final DocumentDataMetadata metadata;
  final DocumentDataContent content;

  const DocumentData({
    required this.metadata,
    required this.content,
  });

  /// Syntax sugar. Should use [DocumentDataMetadata.id].
  DocumentRef get id => metadata.id;

  @override
  List<Object?> get props => [
    metadata,
    content,
  ];

  @override
  int compareTo(DocumentData other) {
    return metadata.id.compareTo(other.metadata.id);
  }

  /// Standard copyWith method.
  DocumentData copyWith({
    DocumentDataMetadata? metadata,
    DocumentDataContent? content,
  }) {
    return DocumentData(
      metadata: metadata ?? this.metadata,
      content: content ?? this.content,
    );
  }

  /// Shorthand for [copyWith].
  DocumentData copyWithId(DocumentRef id) => copyWith(metadata: metadata.copyWith(id: id));
}

/// A Signed version of [DocumentData] that also holds its source [DocumentArtifact].
///
/// This is used when the raw proof is required.
final class DocumentDataWithArtifact extends DocumentData {
  final DocumentArtifact artifact;

  const DocumentDataWithArtifact({
    required super.metadata,
    required super.content,
    required this.artifact,
  });

  @override
  List<Object?> get props => super.props + [artifact];

  @override
  DocumentDataWithArtifact copyWith({
    DocumentDataMetadata? metadata,
    DocumentDataContent? content,
    DocumentArtifact? artifact,
  }) {
    return DocumentDataWithArtifact(
      metadata: metadata ?? this.metadata,
      content: content ?? this.content,
      artifact: artifact ?? this.artifact,
    );
  }
}
