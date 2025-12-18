import 'dart:typed_data';

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;

abstract final class DocumentDataFactory {
  static DocumentDataWithArtifact build({
    DocumentContentType contentType = DocumentContentType.json,
    DocumentType type = DocumentType.proposalDocument,
    SignedDocumentRef? id,
    SignedDocumentRef? ref,
    SignedDocumentRef? template,
    DocumentParameters parameters = const DocumentParameters(),
    List<CatalystId>? collaborators,
    List<CatalystId>? authors,
    DocumentDataContent content = const DocumentDataContent({}),
    DocumentArtifact? artifact,
  }) {
    id ??= DocumentRefFactory.signedDocumentRef();
    artifact ??= DocumentArtifact(Uint8List(0));

    final metadata = DocumentDataMetadata(
      contentType: contentType,
      type: type,
      id: id,
      ref: ref,
      template: template,
      parameters: parameters,
      collaborators: collaborators,
      authors: authors,
    );

    return DocumentDataWithArtifact(
      metadata: metadata,
      content: content,
      artifact: artifact,
    );
  }

  static DocumentData buildDraft({
    DocumentContentType contentType = DocumentContentType.json,
    DocumentType type = DocumentType.proposalDocument,
    DraftRef? id,
    SignedDocumentRef? template,
    DocumentParameters parameters = const DocumentParameters(),
    List<CatalystId>? collaborators,
    List<CatalystId>? authors,
    DocumentDataContent content = const DocumentDataContent({}),
  }) {
    id ??= DocumentRefFactory.draftDocumentRef();

    final metadata = DocumentDataMetadata(
      contentType: contentType,
      type: type,
      id: id,
      template: template,
      parameters: parameters,
      collaborators: collaborators,
      authors: authors,
    );

    return DocumentData(
      metadata: metadata,
      content: content,
    );
  }
}
