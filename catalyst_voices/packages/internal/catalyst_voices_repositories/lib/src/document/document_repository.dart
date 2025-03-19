import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document_data_with_ref_dat.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

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

  /// Return list of all cached documents id for given [id].
  /// It looks for documents in the local storage and draft storage.
  Future<List<DocumentData>> getAllVersionsOfId({
    required String id,
  });

  /// Returns list of locally saved signed documents refs.
  Future<List<SignedDocumentRef>> getCachedDocumentsRefs();

  /// If version is not specified in [ref] method will try to return latest
  /// version of document matching [ref].
  ///
  /// If document does not exist it will throw [DocumentNotFoundException].
  ///
  /// If [DocumentRef] is [SignedDocumentRef] it will look for this document in
  /// local storage.
  ///
  /// If [DocumentRef] is [DraftRef] it will look for this document in local
  /// storage.
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
  });

  /// Returns count of documents matching [ref] id and [type].
  Future<int> getRefCount({
    required DocumentRef ref,
    required DocumentType type,
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

  /// Returns a list of version for given [id].
  ///
  /// Can be used to get versions count.
  Future<List<DocumentsDataWithRefData>> queryVersionsOfId({
    required String id,
  });

  /// Creates/updates a local document draft.
  ///
  /// If watching same draft with [watchDocument] it will emit
  /// change.
  Future<void> upsertDocumentDraft({
    required DocumentData document,
  });

  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  });

  /// Observes matching [ProposalDocument] and emits updates.
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Stream<DocumentsDataWithRefData> watchDocument({
    required DocumentRef ref,
  });

  /// When [unique] is true, only latest versions of each document are returned.
  /// When [getLocalDrafts] is true, local drafts are also returned.
  /// When [authorId] is not null, only documents from
  /// the given author are returned.
  Stream<List<DocumentsDataWithRefData>> watchDocuments({
    required DocumentType type,
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    CatalystId? authorId,
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
  Future<List<DocumentData>> getAllVersionsOfId({
    required String id,
  }) async {
    final localRefs = await _localDocuments.queryVersionsOfId(id: id);
    final drafts = await _drafts.queryVersionsOfId(id: id);

    return [...drafts, ...localRefs];
  }

  @override
  Future<List<SignedDocumentRef>> getCachedDocumentsRefs() {
    return _localDocuments
        .index()
        .then((refs) => refs.cast<SignedDocumentRef>());
  }

  @override
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
  }) async {
    return switch (ref) {
      SignedDocumentRef() => _getSignedDocumentData(ref: ref),
      DraftRef() => _getDraftDocumentData(ref: ref),
    };
  }

  @override
  Future<int> getRefCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    return _localDocuments.getRefCount(ref: ref, type: type);
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
  Future<List<DocumentsDataWithRefData>> queryVersionsOfId({
    required String id,
  }) async {
    final documents = await _localDocuments.queryVersionsOfId(id: id);
    if (documents.isEmpty) return [];
    final templateRef = documents.first.metadata.template!;
    final templateData = await getDocumentData(ref: templateRef);

    return documents
        .map(
          (e) => DocumentsDataWithRefData(
            data: e,
            refData: templateData,
          ),
        )
        .toList();
  }

  @override
  Future<void> upsertDocumentDraft({
    required DocumentData document,
  }) async {
    await _drafts.save(data: document);
  }

  @visibleForTesting
  Stream<List<DocumentsDataWithRefData>> watchAllDocuments({
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    DocumentType? type,
    CatalystId? authorId,
  }) {
    final localDocs = _localDocuments
        .watchAll(
      limit: limit,
      unique: unique,
      type: type,
      authorId: authorId,
    )
        .asyncMap((documents) async {
      final typedDocuments = documents.cast<DocumentData>();
      final results = await Future.wait(
        typedDocuments
            .where((doc) => doc.metadata.template != null)
            .map((documentData) async {
          final templateRef = documentData.metadata.template!;
          final templateData = await _documentDataLock.synchronized(
            () => getDocumentData(ref: templateRef),
          );
          return DocumentsDataWithRefData(
            data: documentData,
            refData: templateData,
          );
        }).toList(),
      );
      return results;
    });

    if (!getLocalDrafts) {
      return localDocs;
    }

    final localDrafts = _drafts
        .watchAll(
      limit: limit,
      type: type,
      authorId: authorId,
    )
        .asyncMap((documents) async {
      final typedDocuments = documents.cast<DocumentData>();
      final results = await Future.wait(
        typedDocuments
            .where((doc) => doc.metadata.template != null)
            .map((documentData) async {
          final templateRef = documentData.metadata.template!;
          final templateData = await _documentDataLock.synchronized(
            () => getDocumentData(ref: templateRef),
          );
          return DocumentsDataWithRefData(
            data: documentData,
            refData: templateData,
          );
        }).toList(),
      );
      return results;
    });

    return Rx.combineLatest2(
      localDocs,
      localDrafts,
      (
        List<DocumentsDataWithRefData> docs,
        List<DocumentsDataWithRefData> drafts,
      ) {
        final combined = {...docs, ...drafts};
        return combined.toList();
      },
    ).distinct(
      listEquals,
    );
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

  @override
  Stream<DocumentsDataWithRefData> watchDocument({
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

        return DocumentsDataWithRefData(
          data: documentData,
          refData: templateData,
        );
      },
    );
  }

  @override
  Stream<List<DocumentsDataWithRefData>> watchDocuments({
    required DocumentType type,
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    CatalystId? authorId,
  }) {
    return watchAllDocuments(
      limit: limit,
      type: type,
      getLocalDrafts: getLocalDrafts,
      authorId: authorId,
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
              ? DocumentsDataWithRefData(
                  data: document,
                  refData: refDocumentData,
                )
              : null;
        },
      );
    });
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
