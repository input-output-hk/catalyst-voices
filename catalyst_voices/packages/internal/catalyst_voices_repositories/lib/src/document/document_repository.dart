import 'dart:async';
import 'dart:convert';

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
    SignedDocumentDataSource localDocuments,
    DocumentDataRemoteSource remoteDocuments,
  ) = DocumentRepositoryImpl;

  /// Making sure document from [ref] is available locally.
  Future<void> cacheDocument({
    required SignedDocumentRef ref,
  });

  /// Stores new draft locally and returns ref to it.
  ///
  /// At the moment we do not support drafts of templates that's why
  /// [template] requires [SignedDocumentRef].
  Future<DraftRef> createDocumentDraft({
    required DocumentType type,
    required DocumentDataContent content,
    required SignedDocumentRef template,
    DraftRef? selfRef,
  });

  /// Deletes a document draft from the local storage.
  Future<void> deleteDocumentDraft({
    required DraftRef ref,
  });

  /// Encodes the [document] to exportable format.
  ///
  /// It does not save the document anywhere on the disk,
  /// it only encodes a document as [Uint8List]
  /// so that it can be saved as a file.
  Future<Uint8List> encodeDocumentForExport({
    required DocumentData document,
  });

  /// Returns list of refs to all published and any refs it may hold.
  ///
  /// Its using documents index api.
  Future<List<SignedDocumentRef>> getAllDocumentsRefs();

  /// Returns list of locally saved signed documents refs.
  Future<List<SignedDocumentRef>> getCachedDocumentsRefs();

  /// Returns matching [ProposalDocument] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalDocument> getProposalDocument({
    required DocumentRef ref,
  });

  /// Returns [ProposalTemplate] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  /// Imports a document [data] previously encoded by [encodeDocumentForExport].
  ///
  /// The document reference will be altered to avoid linking
  /// the imported document to the old document.
  ///
  /// Once imported from the version management point of view this becomes
  /// a new standalone document not related to the previous one.
  ///
  /// Returns the reference to the imported document.
  Future<DocumentRef> importDocument({required Uint8List data});

  Future<void> publishDocument({
    required SignedDocument document,
  });

  /// Returns a list of version of ref object.
  ///
  /// Can be used to get versions count.
  Future<List<String>> queryVersionIds({required String id});

  /// Updates local draft (or drafts if version is not specified)
  /// matching [ref] with given [content].
  ///
  /// If watching same draft with [watchProposalDocument] it will emit
  /// change.
  Future<void> updateDocumentDraft({
    required DraftRef ref,
    required DocumentDataContent content,
  });

  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  });

  /// Observes matching [ProposalDocument] and emits updates.
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Stream<ProposalDocument> watchProposalDocument({
    required DocumentRef ref,
  });

  Stream<List<ProposalDocument>> watchProposalsDocuments({
    int? limit,
    bool unique = false,
  });
}

final class DocumentRepositoryImpl implements DocumentRepository {
  // ignore: unused_field
  final DraftDataSource _drafts;
  final SignedDocumentDataSource _localDocuments;
  final DocumentDataRemoteSource _remoteDocuments;

  final _documentDataLock = Lock();

  DocumentRepositoryImpl(
    this._drafts,
    this._localDocuments,
    this._remoteDocuments,
  );

  @override
  Future<void> cacheDocument({required SignedDocumentRef ref}) async {
    final documentData = await _remoteDocuments.get(ref: ref);

    await _localDocuments.save(data: documentData);
  }

  @override
  Future<DraftRef> createDocumentDraft({
    required DocumentType type,
    required DocumentDataContent content,
    required SignedDocumentRef template,
    DraftRef? selfRef,
  }) async {
    final ref = selfRef ?? DraftRef.generateFirstRef();
    final metadata = DocumentDataMetadata(
      type: type,
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
  Future<void> deleteDocumentDraft({required DraftRef ref}) {
    return _drafts.delete(ref: ref);
  }

  @override
  Future<Uint8List> encodeDocumentForExport({
    required DocumentData document,
  }) async {
    final documentDataDto = DocumentDataDto.fromModel(document);
    final jsonData = documentDataDto.toJson();
    return json.fuse(utf8).encode(jsonData) as Uint8List;
  }

  @override
  Future<List<SignedDocumentRef>> getAllDocumentsRefs() async {
    final remoteRefs = await _remoteDocuments.index();

    return {
      // Note. categories are mocked on backend so we can't not fetch them.
      ...categoriesTemplatesRefs.expand((e) => [e.proposal, e.comment]),
      ...remoteRefs,
    }
        .toList()
        // TODO(damian-molinski): delete it after parsing it ready.
        .sublist(0, 1);
  }

  @override
  Future<List<SignedDocumentRef>> getCachedDocumentsRefs() {
    return _localDocuments
        .index()
        .then((refs) => refs.cast<SignedDocumentRef>());
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
  Future<DocumentRef> importDocument({required Uint8List data}) async {
    final jsonData = json.fuse(utf8).decode(data)! as Map<String, dynamic>;
    final document = DocumentDataDto.fromJson(jsonData).toModel();

    final newMetadata = document.metadata.copyWith(
      selfRef: DraftRef.generateFirstRef(),
    );

    final newDocument = DocumentData(
      metadata: newMetadata,
      content: document.content,
    );

    await _drafts.save(data: newDocument);
    return newDocument.ref;
  }

  @override
  Future<void> publishDocument({required SignedDocument document}) async {
    await _remoteDocuments.publish(document);
  }

  @override
  Future<List<String>> queryVersionIds({required String id}) {
    return _localDocuments.queryVersionIds(id: id);
  }

  @override
  Future<void> updateDocumentDraft({
    required DraftRef ref,
    required DocumentDataContent content,
  }) async {
    await _drafts.update(
      ref: ref,
      content: content,
    );
  }

  Stream<List<DocumentsDataWithRefData>> watchAllDocuments({
    int? limit,
    bool unique = false,
    DocumentType? type,
  }) {
    return _localDocuments
        .watchAll(limit: limit, unique: unique, type: type)
        .distinct()
        .switchMap((documents) async* {
      final results = await Future.wait(
        documents
            .where((doc) => doc.metadata.template != null)
            .map((documentData) async {
          final templateRef = documentData.metadata.template!;
          final templateData = await _documentDataLock.synchronized(
            () => getDocumentData(ref: templateRef),
          );
          return (data: documentData, refData: templateData);
        }),
      );
      yield results;
    });
  }

  @override
  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    return _localDocuments.watchCount(
      ref: ref,
      type: type,
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
  Stream<List<ProposalDocument>> watchProposalsDocuments({
    int? limit,
    bool unique = false,
  }) {
    return watchAllDocuments(
      limit: limit,
      type: DocumentType.proposalDocument,
    ).whereNotNull().map(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).toList(),
        );
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
      selfRef: documentData.metadata.selfRef,
      categoryId: documentData.metadata.categoryId,
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
      selfRef: documentData.metadata.selfRef,
      categoryId: documentData.metadata.categoryId,
    );

    final contentData = documentData.content.data;
    final schema = DocumentSchemaDto.fromJson(contentData).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  Future<DocumentData> _getDraftDocumentData({
    required DraftRef ref,
  }) async {
    return _drafts.get(ref: ref);
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

  Stream<DocumentData?> _watchDraftDocumentData({
    required DraftRef ref,
  }) {
    return _drafts.watch(ref: ref);
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
}
