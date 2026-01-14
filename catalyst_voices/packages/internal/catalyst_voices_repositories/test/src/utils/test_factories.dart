import 'dart:math';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide Document;
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
    SignedDocumentRef? id,
    SignedDocumentRef? proposalRef,
    SignedDocumentRef? template,
    DocumentParameters? parameters,
    List<CatalystId>? authors,
  }) {
    return DocumentDataMetadata.comment(
      id: id ?? DocumentRefFactory.signedDocumentRef(),
      proposalRef: proposalRef ?? DocumentRefFactory.signedDocumentRef(),
      template: template ?? _commentTemplateRef,
      parameters: parameters ?? DocumentParameters({_categoryRef}),
      authors: authors ?? [_catalystId],
    );
  }

  static DocumentDataMetadata proposal({
    DocumentRef? id,
    SignedDocumentRef? template,
    DocumentParameters? parameters,
    List<CatalystId>? authors,
  }) {
    return DocumentDataMetadata.proposal(
      id: id ?? DocumentRefFactory.signedDocumentRef(),
      template: template ?? _proposalTemplateRef,
      parameters: parameters ?? DocumentParameters({_categoryRef}),
      authors: authors ?? [_catalystId],
    );
  }

  static DocumentDataMetadata proposalAction({
    SignedDocumentRef? id,
    SignedDocumentRef? proposalRef,
    DocumentParameters? parameters,
  }) {
    return DocumentDataMetadata.proposalAction(
      id: id ?? DocumentRefFactory.signedDocumentRef(),
      proposalRef: proposalRef ?? DocumentRefFactory.signedDocumentRef(),
      parameters: parameters ?? DocumentParameters({_categoryRef}),
    );
  }

  static DocumentDataMetadata proposalTemplate({
    DocumentRef? id,
    DocumentParameters? parameters,
  }) {
    return DocumentDataMetadata.proposalTemplate(
      id: id ?? DocumentRefFactory.signedDocumentRef(),
      parameters: parameters ?? DocumentParameters({_categoryRef}),
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
