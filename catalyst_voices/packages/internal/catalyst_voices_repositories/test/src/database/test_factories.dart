import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    hide Document;
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:uuid/uuid.dart';

abstract final class DocumentWithMetadataFactory {
  static DocumentEntityWithMetadata build({
    SignedDocumentContent? content,
    SignedDocumentMetadata? metadata,
    DateTime? createdAt,
  }) {
    final document = DocumentFactory.build(
      content: content,
      metadata: metadata,
      createdAt: createdAt,
    );

    final documentMetadata = DocumentMetadataFieldKey.values.map((fieldKey) {
      return switch (fieldKey) {
        DocumentMetadataFieldKey.title => DocumentMetadataFactory.build(
            ver: document.metadata.version,
            fieldKey: fieldKey,
            // This should come from document.metadata
            fieldValue: 'Document[${document.metadata.version}] title',
          ),
      };
    }).toList();

    return (document: document, metadata: documentMetadata);
  }
}

abstract final class DocumentFactory {
  static DocumentEntity build({
    SignedDocumentContent? content,
    SignedDocumentMetadata? metadata,
    DateTime? createdAt,
  }) {
    content ??= const SignedDocumentContent({});

    metadata ??= SignedDocumentMetadata(
      type: SignedDocumentType.proposalDocument,
      id: const Uuid().v7(),
      version: const Uuid().v7(),
    );

    final id = UuidHiLo.from(metadata.id);
    final ver = UuidHiLo.from(metadata.version);

    return DocumentEntity(
      idHi: id.high,
      idLo: id.low,
      verHi: ver.high,
      verLo: ver.low,
      type: metadata.type,
      content: content,
      metadata: metadata,
      createdAt: createdAt ?? DateTime.timestamp(),
    );
  }
}

abstract final class DocumentMetadataFactory {
  static DocumentMetadataEntity build({
    String? ver,
    required DocumentMetadataFieldKey fieldKey,
    required String fieldValue,
  }) {
    ver ??= const Uuid().v7();

    final verHiLo = UuidHiLo.from(ver);

    return DocumentMetadataEntity(
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      fieldKey: fieldKey,
      fieldValue: fieldValue,
    );
  }
}

abstract final class DraftFactory {
  static DraftEntity build({
    SignedDocumentContent? content,
    SignedDocumentMetadata? metadata,
    String? title,
  }) {
    content ??= const SignedDocumentContent({});

    metadata ??= SignedDocumentMetadata(
      type: SignedDocumentType.proposalDocument,
      id: const Uuid().v7(),
      version: const Uuid().v7(),
    );

    title ??= 'Draft[${metadata.id}] title';

    final id = UuidHiLo.from(metadata.id);
    final ver = UuidHiLo.from(metadata.version);

    return DraftEntity(
      idHi: id.high,
      idLo: id.low,
      verHi: ver.high,
      verLo: ver.low,
      type: metadata.type,
      content: content,
      metadata: metadata,
      title: title,
    );
  }
}
