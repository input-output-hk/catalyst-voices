/// Factory classes for creating test DocumentData, DocumentRef, and related objects.
///
/// These factories provide convenient methods for generating test data with
/// predictable, unique values.
library;

import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
// ignore: implementation_imports
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:uuid_plus/uuid_plus.dart';

/// Factory for creating [DocumentData] instances for testing.
abstract final class DocumentDataFactory {
  /// Builds a [DocumentData] with configurable properties.
  ///
  /// All parameters are optional and have sensible defaults for testing.
  static DocumentData build({
    DocumentType type = DocumentType.proposalDocument,
    DocumentRef? selfRef,
    SignedDocumentRef? template,
    SignedDocumentRef? categoryId,
    DocumentDataContent content = const DocumentDataContent({}),
  }) {
    return DocumentData(
      metadata: DocumentDataMetadata(
        type: type,
        selfRef: selfRef ?? DocumentRefFactory.signedDocumentRef(),
        template: template,
        categoryId: categoryId,
      ),
      content: content,
    );
  }
}

/// Factory for creating [DocumentEntity] instances for testing.
abstract final class DocumentFactory {
  /// Builds a [DocumentEntity] with configurable properties.
  ///
  /// All parameters are optional and have sensible defaults for testing.
  static DocumentEntity build({
    DocumentDataContent? content,
    DocumentDataMetadata? metadata,
    DateTime? createdAt,
  }) {
    content ??= const DocumentDataContent({});

    metadata ??= DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      selfRef: DocumentRefFactory.signedDocumentRef(),
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

/// Factory for creating [DocumentMetadataEntity] instances for testing.
abstract final class DocumentMetadataFactory {
  /// Builds a [DocumentMetadataEntity] with configurable properties.
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

/// Factory for creating [DocumentRef] instances for testing.
///
/// Generates random, unique UUIDs using UUIDv7 with a seeded random generator
/// to ensure reproducible test results.
abstract final class DocumentRefFactory {
  static final Random _random = Random(57342052346526);
  static var _timestamp = DateTime.now().millisecondsSinceEpoch;

  /// Generates a random, unique [DraftRef].
  static DraftRef draftRef() {
    return DraftRef.first(randomUuidV7());
  }

  /// Generates a random UUIDv7 string.
  static String randomUuidV7() {
    return const UuidV7().generate(
      options: V7Options(
        _randomDateTime().millisecondsSinceEpoch,
        _randomBytes(10),
      ),
    );
  }

  /// Generates a random, unique [SignedDocumentRef].
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

/// Factory for creating [DocumentEntityWithMetadata] instances for testing.
abstract final class DocumentWithMetadataFactory {
  /// Builds a [DocumentEntityWithMetadata] with configurable properties.
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

/// Factory for creating [DocumentDraftEntity] instances for testing.
abstract final class DraftFactory {
  /// Builds a [DocumentDraftEntity] with configurable properties.
  static DocumentDraftEntity build({
    DocumentDataContent? content,
    DocumentDataMetadata? metadata,
    String? title,
  }) {
    content ??= const DocumentDataContent({});

    metadata ??= DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      selfRef: DocumentRefFactory.draftRef(),
    );

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
