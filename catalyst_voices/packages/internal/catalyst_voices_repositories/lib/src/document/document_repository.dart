import 'dart:convert';
import 'dart:io';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

abstract interface class DocumentRepository {
  factory DocumentRepository(
    SignedDocumentManager signedDocumentManager,
  ) = DocumentRepositoryImpl;

  Future<void> publishDocument(Document document);

  Future<Document> getDocument(String id, {String? version});

  Future<DocumentSchema> getDocumentSchema(String id, {String? version});
}

final class DocumentRepositoryImpl implements DocumentRepository {
  // ignore: unused_field
  final SignedDocumentManager _signedDocumentManager;

  final _documentSchemaLock = Lock();

  DocumentRepositoryImpl(
    this._signedDocumentManager,
  );

  @override
  Future<void> publishDocument(Document document) {
    throw UnimplementedError();
  }

  @override
  Future<Document> getDocument(String id, {String? version}) async {
    // TODO(damian-molinski): use real id when API call is implemented.
    final signedDocument = await _getSignedDocument(Paths.f14Proposal);

    final documentData = DocumentDataDto.fromJson(signedDocument);

    // TODO(damian-molinski): get schema id from signedDocument.
    final documentSchemaId = const Uuid().v7();
    final documentSchema = await getDocumentSchema(documentSchemaId);

    final dto = DocumentDto.fromJsonSchema(documentData, documentSchema);
    final document = dto.toModel(
      documentId: id,
      // TODO(damian-molinski): get version from signedDocument.
      documentVersion: version ?? const Uuid().v7(),
    );

    return document;
  }

  @override
  Future<DocumentSchema> getDocumentSchema(String id, {String? version}) async {
    // Note. When fetch multiple documents with same schema we want
    // to fetch it only once. That's why lock is here so any following
    // calls will get cached value.
    final signedDocument = await _documentSchemaLock.synchronized(() {
      // TODO(damian-molinski): use real id when API call is implemented.
      return _getSignedDocument(Paths.f14ProposalSchema);
    });

    final dto = DocumentSchemaDto.fromJson(signedDocument);
    final documentSchema = dto.toModel(
      documentId: id,
      // TODO(damian-molinski): get version from signedDocument.
      documentVersion: version ?? const Uuid().v7(),
    );

    return documentSchema;
  }

  // TODO(damian-molinski): should return SignedDocument.
  // TODO(damian-molinski): make API call.
  // TODO(damian-molinski): implement caching.
  Future<Map<String, dynamic>> _getSignedDocument(
    String id, {
    // ignore: unused_element
    String? version,
  }) async {
    final encodedData = File(id).readAsStringSync();
    final decodedData = json.decode(encodedData) as Map<String, dynamic>;

    return decodedData;
  }
}
