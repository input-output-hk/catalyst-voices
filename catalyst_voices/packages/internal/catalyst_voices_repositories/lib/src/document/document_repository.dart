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
import 'package:uuid/uuid.dart';

@visibleForTesting
typedef DocumentsDataWithRefData = ({DocumentData data, DocumentData refData});

abstract interface class DocumentRepository {
  factory DocumentRepository(
    DraftDataSource drafts,
    DocumentDataLocalSource localDocuments,
    DocumentDataRemoteSource remoteDocuments,
  ) = DocumentRepositoryImpl;

  /// Observes matching [ProposalDocument] and emits updates.
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Stream<ProposalDocument> watchProposalDocument({
    required DocumentRef ref,
  });

  /// Returns matching [ProposalDocument] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalDocument> getProposalDocument({
    required DocumentRef ref,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  /// Stores new draft locally and returns ref to it.
  ///
  /// At the moment we do not support drafts of templates that's why
  /// [template] requires [SignedDocumentRef].
  ///
  /// If [of] is declared it will be used for this draft and new version
  /// assigned. Think of it as editing published document.
  Future<DraftRef> createProposalDraft({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    SignedDocumentRef? of,
  });

  /// Updates local draft (or drafts if version is not specified)
  /// matching [ref] with given [content].
  ///
  /// If watching same draft with [watchProposalDocument] it will emit
  /// change.
  Future<void> updateProposalDraftContent({
    required DraftRef ref,
    required DocumentDataContent content,
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
  Stream<ProposalDocument> watchProposalDocument({
    required DocumentRef ref,
  }) {
    // TODO(damian-molinski): remove this override once we have API
    ref = ref.copyWith(id: mockedDocumentUuid);

    return watchDocumentWithRef(
      ref: ref,
      refGetter: (data) => data.metadata.template!,
    ).whereNotNull().map(
      (event) {
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
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = ref.copyWith(id: mockedDocumentUuid);

    final documentData = await getDocumentData(ref: ref);
    final templateRef = documentData.metadata.template!;
    final templateData = await getDocumentData(ref: templateRef);

    return _buildProposalDocument(
      documentData: documentData,
      templateData: templateData,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = ref.copyWith(id: mockedTemplateUuid);

    final documentData = await _documentDataLock.synchronized(
      () => getDocumentData(ref: ref),
    );

    return _buildProposalTemplate(documentData: documentData);
  }

  @override
  Future<DraftRef> createProposalDraft({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    SignedDocumentRef? of,
  }) async {
    final id = of?.id ?? const Uuid().v7();
    final version = of != null ? const Uuid().v7() : id;

    final ref = DraftRef(id: id, version: version);
    final metadata = DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      selfRef: ref,
      template: template,
    );

    final data = DocumentData(
      metadata: metadata,
      content: content,
    );

    await _drafts.save(data: data);

    return ref;
  }

  @override
  Future<void> updateProposalDraftContent({
    required DraftRef ref,
    required DocumentDataContent content,
  }) async {
    await _drafts.update(ref: ref, content: content);
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
        .distinct()
        .switchMap<DocumentsDataWithRefData?>((document) {
      if (document == null) {
        return Stream.value(null);
      }

      final ref = refGetter(document);
      final refDocumentStream = _watchDocumentData(
        ref: ref,
        // Synchronized because we may have many documents which are referring
        // to the same template. When loading multiple documents at the same
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
    return switch (ref) {
      SignedDocumentRef() => _watchSignedDocumentData(
          ref: ref,
          synchronizedUpdate: synchronizedUpdate,
        ),
      DraftRef() => _watchDraftDocumentData(ref: ref),
    };
  }

  @visibleForTesting
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
  }) {
    return switch (ref) {
      SignedDocumentRef() => _getSignedDocumentData(ref: ref),
      DraftRef() => _getDraftDocumentData(ref: ref),
    };
  }

  Stream<DocumentData?> _watchSignedDocumentData({
    required SignedDocumentRef ref,
    bool synchronizedUpdate = false,
  }) {
    /// Make sure we're up to date with document ref.
    final documentDataFuture = synchronizedUpdate
        // ignore: discarded_futures
        ? _documentDataLock.synchronized(() => getDocumentData(ref: ref))
        // ignore: discarded_futures
        : getDocumentData(ref: ref);

    final updateStream = Stream.fromFuture(documentDataFuture);
    final localStream = _localDocuments.watch(ref: ref);

    return StreamGroup.merge([updateStream, localStream]);
  }

  Stream<DocumentData?> _watchDraftDocumentData({
    required DraftRef ref,
  }) {
    return _drafts.watch(ref: ref);
  }

  Future<DocumentData> _getSignedDocumentData({
    required SignedDocumentRef ref,
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

  Future<DocumentData> _getDraftDocumentData({
    required DraftRef ref,
  }) async {
    return _drafts.get(ref: ref);
  }
}
