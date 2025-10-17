import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document_data_with_ref_dat.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('DocumentRepository');

DocumentRef _templateResolver(DocumentData data) => data.metadata.template!;

/// Base interface to interact with documents. This interface is used to allow interaction with any
/// document type.
abstract interface class DocumentRepository {
  factory DocumentRepository(
    DraftDataSource drafts,
    SignedDocumentDataSource localDocuments,
    DocumentDataRemoteSource remoteDocuments,
    DocumentFavoriteSource favoriteDocuments,
  ) = DocumentRepositoryImpl;

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

  /// Returns all matching [DocumentData] to given [ref].
  Future<List<DocumentData>> getAllDocumentsData({
    required DocumentRef ref,
  });

  /// Return list of all cached documents id for given [id].
  /// It looks for documents in the local storage and draft storage.
  Future<List<DocumentData>> getAllVersionsOfId({
    required String id,
  });

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
  ///
  /// When [useCache] is false [ref] will be looped up only remotely. If [ref] is referees to
  /// local draft it will throw [DocumentNotFoundException].
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
    bool useCache,
  });

  /// Useful when recovering account and we want to lookup
  /// latest [DocumentData] which of [authorId] and check
  /// username used in [CatalystId] in that document.
  Future<DocumentData?> getLatestDocument({
    CatalystId? authorId,
  });

  /// Returns count of documents matching [ref] id and [type].
  Future<int> getRefCount({
    required DocumentRef ref,
    required DocumentType type,
  });

  Future<DocumentData?> getRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  });

  /// Similar to [watchIsDocumentFavorite] but stops after first emit.
  Future<bool> isDocumentFavorite({
    required DocumentRef ref,
  });

  /// Parses a document [data] previously encoded by [encodeDocumentForExport].
  ///
  /// This method only parses and validates the document structure
  /// without saving it to storage.
  ///
  /// Returns the parsed document data for further validation
  /// before saving with [saveImportedDocument].
  Future<DocumentData> parseDocumentForImport({
    required Uint8List data,
  });

  Future<void> publishDocument({
    required SignedDocument document,
  });

  /// Returns a list of version for given [id].
  ///
  /// Can be used to get versions count.
  Future<List<DocumentsDataWithRefData>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  });

  /// Removes all locally stored documents.
  ///
  /// Returns number of deleted rows.
  ///
  /// if [keepLocalDrafts] is true local drafts will be kept and related templates.
  Future<int> removeAll({
    bool keepLocalDrafts,
  });

  /// Saves a list of documents to the appropriate local storage.
  ///
  /// This method iterates through the provided list of [documents] and saves
  /// each one based on its reference type.
  /// - [DraftRef] documents are saved as drafts.
  /// - [SignedDocumentRef] documents are saved as local signed documents.
  Future<void> saveDocumentBulk(List<DocumentData> documents);

  /// Saves a pre-parsed and validated document to storage.
  ///
  /// The document reference will be altered to avoid linking
  /// the imported document to the old document.
  ///
  /// Returns the reference of the saved document.
  Future<DocumentRef> saveImportedDocument({
    required DocumentData document,
    required CatalystId authorId,
  });

  /// Updates fav status matching [ref].
  Future<void> updateDocumentFavorite({
    required DocumentRef ref,
    required DocumentType type,
    required bool isFavorite,
  });

  /// In context of [document] selfRef:
  ///
  /// - [DraftRef] -> Creates/updates a local document draft.
  /// - [SignedDocumentRef] -> Creates a local document. If matching ref
  /// already exists it will be ignored.
  ///
  /// If watching same draft with [watchDocument] it will emit
  /// change.
  Future<void> upsertDocument({
    required DocumentData document,
  });

  /// Emits list of all favorite ids.
  ///
  /// All returned ids are loose and won't specify version.
  Stream<List<String>> watchAllDocumentsFavoriteIds({
    DocumentType? type,
  });

  /// Emits number of matching documents
  Stream<int> watchCount({
    DocumentRef? refTo,
    DocumentType? type,
  });

  /// Observes matching [DocumentData] as well as [DocumentData] resolved
  /// by [refGetter], usually template, and emits updates.
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Stream<DocumentsDataWithRefData> watchDocument({
    required DocumentRef ref,
    ValueResolver<DocumentData, DocumentRef> refGetter,
  });

  /// When [unique] is true, only latest versions of each document are returned.
  /// When [getLocalDrafts] is true, local drafts are also returned.
  /// When [authorId] is not null, only documents from
  /// the given author are returned.
  // TODO(damian-molinski): refactor all params into object
  Stream<List<DocumentsDataWithRefData>> watchDocuments({
    required DocumentType type,
    ValueResolver<DocumentData, DocumentRef> refGetter,
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    CatalystId? authorId,
    DocumentRef? refTo,
  });

  /// Emits changes to fav status of [ref].
  Stream<bool> watchIsDocumentFavorite({
    required DocumentRef ref,
  });

  /// Looking for document with matching refTo and type.
  /// It return documents data that have a reference that matches [refTo]
  ///
  /// This method is used when we want to find a document that has a reference
  /// to a document that we are looking for.
  ///
  /// For example, we want to find latest document action that were made
  /// on a [refTo] document.
  Stream<DocumentData?> watchRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  });
}

final class DocumentRepositoryImpl implements DocumentRepository {
  final DraftDataSource _drafts;
  final SignedDocumentDataSource _localDocuments;
  final DocumentDataRemoteSource _remoteDocuments;
  final DocumentFavoriteSource _favoriteDocuments;

  final _documentDataLock = Lock();

  DocumentRepositoryImpl(
    this._drafts,
    this._localDocuments,
    this._remoteDocuments,
    this._favoriteDocuments,
  );

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
  Future<List<DocumentData>> getAllDocumentsData({required DocumentRef ref}) async {
    final all = switch (ref) {
      DraftRef() => await _drafts.getAll(ref: ref),
      SignedDocumentRef() => await _localDocuments.getAll(ref: ref),
    }..sort();

    return all;
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
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
    bool useCache = true,
  }) async {
    return switch (ref) {
      SignedDocumentRef() => _getSignedDocumentData(ref: ref, useCache: useCache),
      DraftRef() when !useCache => throw DocumentNotFoundException(
        ref: ref,
        message: '$ref can not be resolved while not using cache',
      ),
      DraftRef() => _getDraftDocumentData(ref: ref),
    };
  }

  @override
  Future<DocumentData?> getLatestDocument({
    CatalystId? authorId,
  }) async {
    final latestDocument = await _localDocuments.getLatest(authorId: authorId);
    final latestDraft = await _drafts.getLatest(authorId: authorId);

    return [latestDocument, latestDraft].nonNulls.sorted((a, b) => a.compareTo(b)).firstOrNull;
  }

  @override
  Future<int> getRefCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    return _localDocuments.getRefCount(ref: ref, type: type);
  }

  @override
  Future<DocumentData?> getRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  }) {
    return _localDocuments.getRefToDocumentData(refTo: refTo, type: type);
  }

  @override
  Future<bool> isDocumentFavorite({required DocumentRef ref}) {
    assert(!ref.isExact, 'Favorite ref have to be loose!');

    return _favoriteDocuments.watchIsDocumentFavorite(ref.id).first;
  }

  @override
  Future<DocumentData> parseDocumentForImport({required Uint8List data}) async {
    final document = _parseDocumentData(data);
    _validateDocumentMetadata(document);
    return document;
  }

  @override
  Future<void> publishDocument({required SignedDocument document}) async {
    await _remoteDocuments.publish(document);

    final doc = DocumentDataFactory.create(document);
    await _localDocuments.save(data: doc);
  }

  @override
  Future<List<DocumentsDataWithRefData>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  }) async {
    List<DocumentData> documents;
    final localDocuments = await _localDocuments.queryVersionsOfId(id: id);
    if (includeLocalDrafts) {
      final localDrafts = await _drafts.queryVersionsOfId(id: id);
      documents = [...localDocuments, ...localDrafts];
    } else {
      documents = localDocuments;
    }
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
  Future<int> removeAll({
    bool keepLocalDrafts = false,
  }) async {
    final deletedDrafts = keepLocalDrafts ? 0 : await _drafts.deleteAll();
    final deletedDocuments = keepLocalDrafts
        ? await _localDocuments.deleteAllRespectingLocalDrafts()
        : await _localDocuments.deleteAll();

    return deletedDrafts + deletedDocuments;
  }

  Future<void> saveDocumentBulk(List<DocumentData> documents) async {
    final signedDocs = documents.where((element) => element.ref is SignedDocumentRef);
    final draftDocs = documents.where((element) => element.ref is DraftRef);

    if (signedDocs.isNotEmpty) {
      await _localDocuments.saveAll(signedDocs);
    }
    if (draftDocs.isNotEmpty) {
      await _drafts.saveAll(draftDocs);
    }
  }

  @override
  Future<DocumentRef> saveImportedDocument({
    required DocumentData document,
    required CatalystId authorId,
  }) async {
    final newMetadata = document.metadata.copyWith(
      selfRef: DraftRef.generateFirstRef(),
      authors: Optional([authorId]),
    );

    final newDocument = DocumentData(
      metadata: newMetadata,
      content: document.content,
    );

    await _drafts.save(data: newDocument);
    return newDocument.metadata.selfRef;
  }

  @override
  Future<void> updateDocumentFavorite({
    required DocumentRef ref,
    required DocumentType type,
    required bool isFavorite,
  }) {
    assert(!ref.isExact, 'Favorite ref have to be loose!');

    return _favoriteDocuments.updateDocumentFavorite(
      ref.id,
      type: type,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<void> upsertDocument({
    required DocumentData document,
  }) async {
    switch (document.metadata.selfRef) {
      case DraftRef():
        await _drafts.save(data: document);
      case SignedDocumentRef():
        await _localDocuments.save(data: document);
    }
  }

  @visibleForTesting
  Stream<List<DocumentsDataWithRefData>> watchAllDocuments({
    required ValueResolver<DocumentData, DocumentRef> refGetter,
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    DocumentType? type,
    CatalystId? authorId,
    DocumentRef? refTo,
  }) {
    final localDocs = _localDocuments
        .watchAll(
          limit: limit,
          unique: unique,
          type: type,
          authorId: authorId,
          refTo: refTo,
        )
        .asyncMap(
          (documents) async => _processDocuments(
            documents: documents,
            refGetter: refGetter,
          ),
        );

    if (!getLocalDrafts) {
      return localDocs;
    }

    final localDrafts = _drafts
        .watchAll(
          limit: limit,
          type: type,
          authorId: authorId,
        )
        .asyncMap(
          (documents) async => _processDocuments(
            documents: documents,
            refGetter: refGetter,
          ),
        );

    // Combine streams
    return Rx.combineLatest2<
          List<DocumentsDataWithRefData>,
          List<DocumentsDataWithRefData>,
          List<DocumentsDataWithRefData>
        >(
          localDocs,
          localDrafts,
          (docs, drafts) {
            final combined = {...docs, ...drafts};
            return combined.toList();
          },
        )
        .distinct(listEquals);
  }

  @override
  Stream<List<String>> watchAllDocumentsFavoriteIds({
    DocumentType? type,
  }) {
    return _favoriteDocuments.watchAllFavoriteIds(type: type);
  }

  @override
  Stream<int> watchCount({
    DocumentRef? refTo,
    DocumentType? type,
  }) {
    return _localDocuments.watchCount(
      refTo: refTo,
      type: type,
    );
  }

  @override
  Stream<DocumentsDataWithRefData> watchDocument({
    required DocumentRef ref,
    ValueResolver<DocumentData, DocumentRef> refGetter = _templateResolver,
  }) {
    return watchDocumentWithRef(
      ref: ref,
      refGetter: refGetter,
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
    ValueResolver<DocumentData, DocumentRef> refGetter = _templateResolver,
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    CatalystId? authorId,
    DocumentRef? refTo,
  }) {
    return watchAllDocuments(
      refGetter: refGetter,
      limit: limit,
      type: type,
      unique: unique,
      getLocalDrafts: getLocalDrafts,
      authorId: authorId,
      refTo: refTo,
    );
  }

  @visibleForTesting
  Stream<DocumentsDataWithRefData?> watchDocumentWithRef({
    required DocumentRef ref,
    required ValueResolver<DocumentData, DocumentRef> refGetter,
  }) {
    return _watchDocumentData(ref: ref).distinct().switchMap<DocumentsDataWithRefData?>((document) {
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

  @override
  Stream<bool> watchIsDocumentFavorite({required DocumentRef ref}) {
    assert(!ref.isExact, 'Favorite ref have to be loose!');

    return _favoriteDocuments.watchIsDocumentFavorite(ref.id);
  }

  @override
  Stream<DocumentData?> watchRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
    ValueResolver<DocumentData, DocumentRef> refGetter = _templateResolver,
  }) {
    return _localDocuments.watchRefToDocumentData(refTo: refTo, type: type).distinct();
  }

  Future<DocumentData> _getDraftDocumentData({
    required DraftRef ref,
  }) async {
    return _drafts.get(ref: ref);
  }

  Future<DocumentData> _getSignedDocumentData({
    required SignedDocumentRef ref,
    bool useCache = true,
  }) async {
    // if version is not specified we're asking remote for latest version
    // if remote does not know about this id its probably draft so
    // local will return latest version
    if (!ref.isExact) {
      final latestVersion = await _remoteDocuments.getLatestVersion(ref.id);
      ref = ref.copyWith(version: Optional(latestVersion));
    }

    final isCached = useCache && await _localDocuments.exists(ref: ref);
    if (isCached) {
      return _localDocuments.get(ref: ref);
    }

    final document = await _remoteDocuments.get(ref: ref);

    if (useCache) {
      await _localDocuments.save(data: document);
    }

    return document;
  }

  bool _isDocumentMetadataValid(DocumentData document) {
    final template = document.metadata.template;
    final category = document.metadata.categoryId;
    final documentType = document.metadata.type;

    final isInvalidTemplate = template == null || !template.isValid;
    final isInvalidCategory = category == null || !category.isValid;
    final isInvalidType = documentType == DocumentType.unknown;
    final isInvalidProposal = isInvalidTemplate || isInvalidType || isInvalidCategory;

    return !isInvalidProposal;
  }

  DocumentData _parseDocumentData(Uint8List data) {
    try {
      final jsonData = json.fuse(utf8).decode(data)! as Map<String, dynamic>;
      return DocumentDataDto.fromJson(jsonData).toModel();
    } catch (e) {
      throw DocumentImportInvalidDataException(e);
    }
  }

  Future<List<DocumentsDataWithRefData>> _processDocuments({
    required List<DocumentData> documents,
    required ValueResolver<DocumentData, DocumentRef> refGetter,
  }) async {
    final results = <DocumentsDataWithRefData>[];

    for (final documentData in documents) {
      try {
        if (!_isDocumentMetadataValid(documentData)) {
          _logger.warning(
            'Invalid document metadata for document ${documentData.metadata.selfRef}, skipping',
          );
          if (documentData.metadata.selfRef is DraftRef) {
            unawaited(deleteDocumentDraft(ref: documentData.metadata.selfRef as DraftRef));
          }
          continue;
        }

        final templateRef = documentData.metadata.template!;
        final templateData = await _documentDataLock.synchronized(
          () => getDocumentData(ref: templateRef),
        );
        results.add(
          DocumentsDataWithRefData(
            data: documentData,
            refData: templateData,
          ),
        );
      } catch (e, st) {
        _logger.warning('Error processing document ${documentData.metadata.selfRef}', e, st);
        if (documentData.metadata.selfRef is DraftRef) {
          unawaited(deleteDocumentDraft(ref: documentData.metadata.selfRef as DraftRef));
        }
        continue;
      }
    }

    return results;
  }

  void _validateDocumentMetadata(DocumentData document) {
    if (!_isDocumentMetadataValid(document)) {
      throw const DocumentImportInvalidDataException(SignedDocumentMetadataMalformed);
    }
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
