import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
final class DocumentData extends Equatable {
  final DocumentDataMetadata metadata;
  final DocumentDataContent content;

  const DocumentData({
    required this.metadata,
    required this.content,
  });

  /// Syntax sugar. Should use [DocumentDataMetadata.selfRef].
  DocumentRef get ref => metadata.selfRef;

  @override
  List<Object?> get props => [
        metadata,
        content,
      ];
}
