import 'dart:math';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:uuid_plus/uuid_plus.dart';

abstract final class DocumentDataFactory {
  static DocumentData build({
    DocumentDataMetadata? metadata,
    DocumentDataContent? content,
  }) {
    return DocumentData(
      metadata: metadata ?? DocumentDataMetadataFactory.proposal(),
      content: content ?? const DocumentDataContent({}),
    );
  }
}

abstract final class DocumentDataMetadataFactory {
  static final _categoryRef = DocumentRefFactory.signedDocumentRef();
  static final _commentTemplateRef = DocumentRefFactory.signedDocumentRef();
  static final _proposalTemplateRef = DocumentRefFactory.signedDocumentRef();
  static final _catalystId = CatalystId(host: 'test', role0Key: Uint8List(32));

  static DocumentDataMetadata comment({
    SignedDocumentRef? selfRef,
    SignedDocumentRef? proposalRef,
    SignedDocumentRef? template,
    DocumentParameters? parameters,
    List<CatalystId>? authors,
  }) {
    return DocumentDataMetadata.comment(
      selfRef: selfRef ?? DocumentRefFactory.signedDocumentRef(),
      proposalRef: proposalRef ?? DocumentRefFactory.signedDocumentRef(),
      template: template ?? _commentTemplateRef,
      parameters: parameters ?? DocumentParameters({_categoryRef}),
      authors: authors ?? [_catalystId],
    );
  }

  static DocumentDataMetadata proposal({
    DocumentRef? selfRef,
    SignedDocumentRef? template,
    DocumentParameters? parameters,
    List<CatalystId>? authors,
  }) {
    return DocumentDataMetadata.proposal(
      selfRef: selfRef ?? DocumentRefFactory.signedDocumentRef(),
      template: template ?? _proposalTemplateRef,
      parameters: parameters ?? DocumentParameters({_categoryRef}),
      authors: authors ?? [_catalystId],
    );
  }

  static DocumentDataMetadata proposalAction({
    SignedDocumentRef? selfRef,
    SignedDocumentRef? proposalRef,
    DocumentParameters? parameters,
  }) {
    return DocumentDataMetadata.proposalAction(
      selfRef: selfRef ?? DocumentRefFactory.signedDocumentRef(),
      proposalRef: proposalRef ?? DocumentRefFactory.signedDocumentRef(),
      parameters: parameters ?? DocumentParameters({_categoryRef}),
    );
  }

  static DocumentDataMetadata proposalTemplate({
    DocumentRef? selfRef,
    DocumentParameters? parameters,
  }) {
    return DocumentDataMetadata.proposalTemplate(
      selfRef: selfRef ?? DocumentRefFactory.signedDocumentRef(),
      parameters: parameters ?? DocumentParameters({_categoryRef}),
    );
  }
}

abstract final class DocumentFactory {
  static DocumentEntity build({
    DocumentDataContent? content,
    DocumentDataMetadata? metadata,
    DateTime? createdAt,
  }) {
    content ??= const DocumentDataContent({});
    metadata ??= DocumentDataMetadataFactory.proposal();

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
    ver ??= DocumentRefFactory.randomUuidV7();
    final verHiLo = UuidHiLo.from(ver);

    return DocumentMetadataEntity(
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      fieldKey: fieldKey,
      fieldValue: fieldValue,
    );
  }
}

abstract final class DocumentRefFactory {
  static final Random _random = Random(57342052346526);
  static var _timestamp = DateTime.now().millisecondsSinceEpoch;

  /// Generates random, unique [DraftRef].
  static DraftRef draftRef() {
    return DraftRef.first(randomUuidV7());
  }

  static String randomUuidV7() {
    return const UuidV7().generate(
      options: V7Options(
        _randomDateTime().millisecondsSinceEpoch,
        _randomBytes(10),
      ),
    );
  }

  /// Generates random, unique [SignedDocumentRef].
  static SignedDocumentRef signedDocumentRef() {
    return SignedDocumentRef.first(randomUuidV7());
  }

  static List<int> _randomBytes(int length) {
    return List.generate(length, (index) => _random.nextInt(256));
  }

  /// Generates a random date & time, where each method call is guaranteed to return a newer date.
  static DateTime _randomDateTime() {
    final timestamp = _timestamp;
    _timestamp++;

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

abstract final class DocumentWithMetadataFactory {
  static DocumentEntityWithMetadata build({
    DocumentDataContent? content,
    DocumentDataMetadata? metadata,
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

abstract final class DraftFactory {
  static DocumentDraftEntity build({
    DocumentDataContent? content,
    DocumentDataMetadata? metadata,
    String? title,
  }) {
    content ??= const DocumentDataContent({});
    metadata ??= DocumentDataMetadataFactory.proposal();

    title ??= 'Draft[${metadata.id}] title';

    final id = UuidHiLo.from(metadata.id);
    final ver = UuidHiLo.from(metadata.version);

    return DocumentDraftEntity(
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
