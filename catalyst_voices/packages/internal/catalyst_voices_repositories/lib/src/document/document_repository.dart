import 'dart:async';

import 'package:async/async.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/transformers.dart';
import 'package:synchronized/synchronized.dart';

@visibleForTesting
typedef DocumentsDataWithRefData = ({DocumentData data, DocumentData refData});

abstract interface class DocumentRepository {
  factory DocumentRepository(
    DraftDataSource drafts,
    DocumentDataLocalSource localDocuments,
    DocumentDataRemoteSource remoteDocuments,
  ) = DocumentRepositoryImpl;

  Stream<ProposalDocument?> watchProposalDocument({
    required DocumentRef ref,
  });

  Future<ProposalDocument> getProposalDocument({
    required DocumentRef ref,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });
}

final class DocumentRepositoryImpl implements DocumentRepository {
  // ignore: unused_field
  final DraftDataSource _drafts;
  final DocumentDataLocalSource _localDocuments;
  final DocumentDataRemoteSource _remoteDocuments;

  final _documentDataLock = Lock();

  DocumentRepositoryImpl(
    this._drafts,
    this._localDocuments,
    this._remoteDocuments,
  );

  @override
  Stream<ProposalDocument?> watchProposalDocument({
    required DocumentRef ref,
  }) {
    // TODO(damian-molinski): remove this override once we have API
    ref = ref.copyWith(id: mockedDocumentUuid);

    return watchDocumentWithRef(
      ref: ref,
      refGetter: (data) => data.metadata.template!,
    ).map(
      (event) {
        if (event == null) {
          return null;
        }
        final documentData = event.data;
        final templateData = event.refData;

        return _buildProposalDocument(
          documentData: documentData,
          templateData: templateData,
        );
      },
    );
  }

  @override
  Future<ProposalDocument> getProposalDocument({
    required DocumentRef ref,
  }) {
    return watchProposalDocument(ref: ref)
        .firstWhere((proposal) => proposal != null)
        .then((proposal) => proposal!);
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = ref.copyWith(id: mockedTemplateUuid);

    final documentData = await getDocumentData(ref: ref);

    return _buildProposalTemplate(documentData: documentData);
  }

  ProposalDocument _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final template = _buildProposalTemplate(documentData: templateData);

    final metadata = ProposalMetadata(
      id: documentData.metadata.id,
      version: documentData.metadata.version,
    );

    final content = DocumentDataContentDto.fromModel(
      documentData.content,
    );
    final schema = template.schema;
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }

  ProposalTemplate _buildProposalTemplate({
    required DocumentData documentData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalTemplate,
      'Not a proposalTemplate document data type',
    );

    final metadata = ProposalTemplateMetadata(
      id: documentData.metadata.id,
      version: documentData.metadata.version,
    );

    final contentData = documentData.content.data;
    final schema = DocumentSchemaDto.fromJson(contentData).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  @visibleForTesting
  Stream<DocumentsDataWithRefData?> watchDocumentWithRef({
    required DocumentRef ref,
    required ValueResolver<DocumentData, DocumentRef> refGetter,
  }) {
    return _watchDocumentData(ref: ref)
        .switchMap<DocumentsDataWithRefData?>((document) {
      if (document == null) {
        return Stream.value(null);
      }

      final ref = refGetter(document);
      final refDocumentStream = _watchDocumentData(
        ref: ref,
        // Synchronized because we may have many document which are referring
        // to same template. When loading multiple documents at same
        // time we want to fetch only once template.
        synchronizedUpdate: true,
      );

      return refDocumentStream.map<DocumentsDataWithRefData?>(
        (refDocumentData) {
          return refDocumentData != null
              ? (data: document, refData: refDocumentData)
              : null;
        },
      );
    });
  }

  Stream<DocumentData?> _watchDocumentData({
    required DocumentRef ref,
    bool synchronizedUpdate = false,
  }) {
    /// Make sure we're update to date with document ref.
    final documentDataFuture = synchronizedUpdate
        // ignore: discarded_futures
        ? _documentDataLock.synchronized(() => getDocumentData(ref: ref))
        // ignore: discarded_futures
        : getDocumentData(ref: ref);

    final updateStream = Stream.fromFuture(documentDataFuture);
    final localStream = _localDocuments.watch(ref: ref);

    return StreamGroup.merge([updateStream, localStream]);
  }

  @visibleForTesting
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
  }) async {
    // if version is not specified we're asking remote for latest version
    // if remote does not know about this id its probably draft so
    // local will return latest version
    if (!ref.isExact) {
      final latestVersion = await _remoteDocuments.getLatestVersion(ref.id);
      ref = ref.copyWith(version: Optional(latestVersion));
    }

    final isCached = await _localDocuments.exists(ref: ref);
    if (isCached) {
      return _localDocuments.get(ref: ref);
    }
    final remoteData = await _remoteDocuments.get(ref: ref);

    await _localDocuments.save(data: remoteData);

    return remoteData;
  }
}
