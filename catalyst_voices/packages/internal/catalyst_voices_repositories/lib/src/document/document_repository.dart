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
// TODO(damian-molinski): split into local drafts and signed documents repositories
abstract interface class DocumentRepository {
  factory DocumentRepository(
    CatalystDatabase db,
    DraftDataSource drafts,
    SignedDocumentDataSource localDocuments,
    DocumentDataRemoteSource remoteDocuments,
  ) = DocumentRepositoryImpl;

  /// Analyzes the database to gather statistics and potentially optimize it.
  ///
  /// This can be a long-running operation, so it should be used judiciously,
  /// for example, during application startup or in a background process
  /// for maintenance.
  Future<void> analyzeDatabase();

  /// Deletes a document draft from the local storage.
  Future<void> deleteDocumentDraft({
    required DraftRef id,
  });

  /// Encodes the [document] to exportable format.
  ///
  /// It does not save the document anywhere on the disk,
  /// it only encodes a document as [Uint8List]
  /// so that it can be saved as a file.
  Future<Uint8List> encodeDocumentForExport({
    required DocumentData document,
  });

  /// Returns all matching [DocumentData] to given [id].
  Future<List<DocumentData>> findAllVersions({
    required DocumentRef id,
  });

  /// Return list of all cached documents id for given [id].
  /// It looks for documents in the local storage and draft storage.
  Future<List<DocumentData>> getAllVersionsOfId({
    required String id,
  });

  /// Similar to [getDocumentData] but returns only [DocumentArtifact].
  ///
  /// If document does not exist it will throw [DocumentNotFoundException].
  Future<DocumentArtifact> getDocumentArtifact({
    required SignedDocumentRef id,
  });

  /// Retrieves the data for a specific document, resolving the correct version.
  ///
  /// If [id] is [DocumentRef.isExact], fetches that specific version.
  /// If [id] is [DocumentRef.isLoose], retrieves the most recent version based on [DocumentData]
  /// ver timestamp (UUIDv7).
  ///
  /// If [id] is [SignedDocumentRef], the method targets signed documents only
  /// If [id] is [DraftRef], the method targets local-drafts only
  ///
  /// Returns the [DocumentData] matching the resolved reference, or `null` if not found.
  Future<DocumentData> getDocumentData({
    required DocumentRef id,
  });

  /// Useful when recovering account and we want to lookup
  /// latest [DocumentData] which of [originalAuthorId] and check
  /// username used in [CatalystId] in that document.
  Future<DocumentData?> getLatestDocument({
    CatalystId? originalAuthorId,
  });

  /// Returns latest matching [DocumentRef] version with same id as [id].
  Future<DocumentRef?> getLatestOf({required DocumentRef id});

  /// Returns count of documents matching [referencing] id and [type].
  Future<int> getRefCount({
    required DocumentRef referencing,
    required DocumentType type,
  });

  Future<DocumentData?> getRefToDocumentData({
    required DocumentRef referencing,
    required DocumentType type,
  });

  /// Gets [DocumentDataWithArtifact] from remote. This method do not access any of cache.
  // TODO(damian-molinski): refactor documents sync into object which has remote source
  // so this could be removed from here.
  Future<DocumentDataWithArtifact> getRemoteDocumentDataWithArtifact({
    required SignedDocumentRef id,
  });

  /// Looks up all signed document refs according to [filters].
  ///
  /// Response is paginated using [page] and [limit].
  Future<DocumentIndex> index({
    required int page,
    required int limit,
    required DocumentIndexFilters filters,
  });

  /// Filters and returns only the DocumentRefs from [ids] which are cached.
  Future<List<DocumentRef>> isCachedBulk({
    required List<DocumentRef> ids,
  });

  Future<bool> isFavorite(DocumentRef id);

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

  /// Saves a pre-parsed and validated document to storage.
  ///
  /// The document reference will be altered to avoid linking
  /// the imported document to the old document.
  ///
  /// Returns the reference of the saved document.
  Future<DraftRef> saveImportedDocument({
    required DocumentData document,
    required CatalystId authorId,
  });

  /// Saves a list of documents to the local storage.
  ///
  /// This method iterates through the provided list of [documents] and saves
  /// each one based on its reference type.
  ///
  /// Method saves only signed documents with artifacts.
  Future<void> saveSignedDocumentBulk(List<DocumentDataWithArtifact> documents);

  /// Creates/updates a local document draft.
  ///
  /// If watching same draft with [watchDocument] it will emit change.
  ///
  /// This method do not work for signed documents.
  Future<void> upsertLocalDraftDocument({
    required DocumentData document,
  });

  /// Emits number of matching documents
  Stream<int> watchCount({
    DocumentRef? referencing,
    DocumentType? type,
  });

  /// Observes matching [DocumentData] as well as [DocumentData] resolved
  /// by [refGetter], usually template, and emits updates.
  ///
  /// Source of data depends whether [id] is [SignedDocumentRef] or [DraftRef].
  Stream<DocumentsDataWithRefData> watchDocument({
    required DocumentRef id,
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
    DocumentRef? referencing,
  });

  /// Looking for document with matching refTo and type.
  /// It return documents data that have a reference that matches [referencing]
  ///
  /// This method is used when we want to find a document that has a reference
  /// to a document that we are looking for.
  ///
  /// For example, we want to find latest document action that were made
  /// on a [referencing] document.
  Stream<DocumentData?> watchRefToDocumentData({
    required DocumentRef referencing,
    required DocumentType type,
  });
}

final class DocumentRepositoryImpl implements DocumentRepository {
  final CatalystDatabase _db;
  final DraftDataSource _drafts;
  final SignedDocumentDataSource _localDocuments;
  final DocumentDataRemoteSource _remoteDocuments;

  final _documentDataLock = Lock();

  DocumentRepositoryImpl(
    this._db,
    this._drafts,
    this._localDocuments,
    this._remoteDocuments,
  );

  @override
  Future<void> analyzeDatabase() => _db.analyze();

  @override
  Future<void> deleteDocumentDraft({required DraftRef id}) {
    return _drafts.delete(ref: id);
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
  Future<List<DocumentData>> findAllVersions({required DocumentRef id}) async {
    final all = switch (id) {
      DraftRef() => await _drafts.findAll(id: id),
      SignedDocumentRef() => await _localDocuments.findAll(id: id),
    }..sort();

    return all;
  }

  @override
  Future<List<DocumentData>> getAllVersionsOfId({
    required String id,
  }) async {
    final localRefs = await _localDocuments.findAll(id: SignedDocumentRef(id: id));
    final drafts = await _drafts.findAll(id: DraftRef(id: id));

    return [...drafts, ...localRefs];
  }

  @override
  Future<DocumentArtifact> getDocumentArtifact({required SignedDocumentRef id}) async {
    final artifact = await _getSignedDocumentAndCacheAs<DocumentArtifact>(
      ref: id,
      fromCache: _localDocuments.getArtifact,
      fromDocument: (document) => document.artifact,
    );

    if (artifact == null) {
      throw DocumentNotFoundException(ref: id);
    }

    return artifact;
  }

  @override
  Future<DocumentData> getDocumentData({
    required DocumentRef id,
  }) async {
    final documentData = switch (id) {
      SignedDocumentRef() => await _getSignedDocumentData(id: id),
      DraftRef() => await _getDraftDocumentData(ref: id),
    };

    if (documentData == null) {
      throw DocumentNotFoundException(ref: id);
    }

    return documentData;
  }

  // TODO(damian-molinski): this will be removed and replaced on performance branch so
  // i'm not implementing drafts now.
  @override
  Future<DocumentData?> getLatestDocument({
    CatalystId? originalAuthorId,
  }) async {
    final latestDocument = await _localDocuments.findFirst(originalAuthorId: originalAuthorId);
    final latestDraft = await _drafts.findFirst();

    return [latestDocument, latestDraft].nonNulls.sorted((a, b) => a.compareTo(b)).firstOrNull;
  }

  // TODO(damian-molinski): consider also checking with remote source.
  @override
  Future<DocumentRef?> getLatestOf({required DocumentRef id}) async {
    final draft = await _drafts.getLatestRefOf(id);
    if (draft != null) {
      return draft;
    }

    return _localDocuments.getLatestRefOf(id);
  }

  @override
  Future<int> getRefCount({
    required DocumentRef referencing,
    required DocumentType type,
  }) {
    return _localDocuments.count(referencing: referencing, type: type);
  }

  @override
  Future<DocumentData?> getRefToDocumentData({
    required DocumentRef referencing,
    required DocumentType type,
  }) {
    return _localDocuments.findFirst(referencing: referencing, type: type);
  }

  @override
  Future<DocumentDataWithArtifact> getRemoteDocumentDataWithArtifact({
    required SignedDocumentRef id,
  }) async {
    final document = await _remoteDocuments.get(id);

    if (document == null) {
      throw DocumentNotFoundException(ref: id);
    }

    return document;
  }

  @override
  Future<DocumentIndex> index({
    required int page,
    required int limit,
    required DocumentIndexFilters filters,
  }) {
    return _remoteDocuments.index(
      page: page,
      limit: limit,
      filters: filters,
    );
  }

  @override
  Future<List<DocumentRef>> isCachedBulk({required List<DocumentRef> ids}) {
    final signedRefs = ids.whereType<SignedDocumentRef>().toList();
    final localDraftsRefs = ids.whereType<DraftRef>().toList();

    final signedDocsSave = _localDocuments.filterExisting(signedRefs);
    final draftsDocsSave = _drafts.filterExisting(localDraftsRefs);

    return [
      signedDocsSave,
      draftsDocsSave,
    ].wait.then((value) => value.expand((refs) => refs).toList());
  }

  @override
  Future<bool> isFavorite(DocumentRef id) {
    return _db.localMetadataDao.isFavorite(id.id);
  }

  @override
  Future<DocumentData> parseDocumentForImport({required Uint8List data}) async {
    final document = _parseDocumentData(data);
    _validateDocumentMetadata(document);
    return document;
  }

  @override
  Future<void> publishDocument({required SignedDocument document}) async {
    final doc = DocumentDataFactory.create(document);

    await _remoteDocuments.publish(doc.artifact);
    await _localDocuments.save(data: doc);
  }

  @override
  Future<List<DocumentsDataWithRefData>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  }) async {
    List<DocumentData> documents;
    final localDocuments = await _localDocuments.findAll(id: SignedDocumentRef(id: id));
    if (includeLocalDrafts) {
      final localDrafts = await _drafts.findAll(id: DraftRef(id: id));
      documents = [...localDocuments, ...localDrafts];
    } else {
      documents = localDocuments;
    }
    if (documents.isEmpty) return [];
    final templateRef = documents.first.metadata.template!;
    final templateData = await getDocumentData(id: templateRef);

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
    final deletedDrafts = keepLocalDrafts ? 0 : await _drafts.delete();
    final excludeTypes = keepLocalDrafts ? [DocumentType.proposalTemplate] : null;
    final deletedDocuments = await _localDocuments.delete(excludeTypes: excludeTypes);

    return deletedDrafts + deletedDocuments;
  }

  @override
  Future<DraftRef> saveImportedDocument({
    required DocumentData document,
    required CatalystId authorId,
  }) async {
    final id = DraftRef.generateFirstRef();
    final newMetadata = document.metadata.copyWith(
      id: id,
      authors: Optional([authorId]),
    );

    final newDocument = DocumentData(
      metadata: newMetadata,
      content: document.content,
    );

    await _drafts.save(data: newDocument);

    return id;
  }

  @override
  Future<void> saveSignedDocumentBulk(List<DocumentDataWithArtifact> documents) async {
    assert(
      documents.every((element) => element.metadata.id.isSigned),
      'Only signed documents are supported',
    );

    return _localDocuments.saveAll(documents);
  }

  @override
  Future<void> upsertLocalDraftDocument({
    required DocumentData document,
  }) async {
    assert(document.metadata.id.isDraft, 'Only draft documents are supported');

    await _drafts.save(data: document);
  }

  @visibleForTesting
  Stream<List<DocumentsDataWithRefData>> watchAllDocuments({
    required ValueResolver<DocumentData, DocumentRef> refGetter,
    int? limit,
    bool unique = false,
    bool getLocalDrafts = false,
    DocumentType? type,
    CatalystId? authorId,
    DocumentRef? referencing,
  }) {
    final localDocs = _localDocuments
        .watchAll(
          latestOnly: unique,
          type: type,
          originalAuthorId: authorId,
          referencing: referencing,
          limit: limit ?? 200,
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
          type: type,
          limit: limit ?? 100,
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
  Stream<int> watchCount({
    DocumentRef? referencing,
    DocumentType? type,
  }) {
    return _localDocuments.watchCount(
      referencing: referencing,
      type: type,
    );
  }

  @override
  Stream<DocumentsDataWithRefData> watchDocument({
    required DocumentRef id,
    ValueResolver<DocumentData, DocumentRef> refGetter = _templateResolver,
  }) {
    return watchDocumentWithRef(
      ref: id,
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
    DocumentRef? referencing,
  }) {
    return watchAllDocuments(
      refGetter: refGetter,
      limit: limit,
      type: type,
      unique: unique,
      getLocalDrafts: getLocalDrafts,
      authorId: authorId,
      referencing: referencing,
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
  Stream<DocumentData?> watchRefToDocumentData({
    required DocumentRef referencing,
    required DocumentType type,
    ValueResolver<DocumentData, DocumentRef> refGetter = _templateResolver,
  }) {
    return _localDocuments.watch(referencing: referencing, type: type).distinct();
  }

  Future<DocumentData?> _getDraftDocumentData({
    required DraftRef ref,
  }) async {
    return _drafts.get(ref);
  }

  Future<T?> _getSignedDocumentAndCacheAs<T>({
    required SignedDocumentRef ref,
    required ValueResolver<SignedDocumentRef, Future<T?>> fromCache,
    required ValueResolver<DocumentDataWithArtifact, T> fromDocument,
  }) async {
    // if version is not specified we're asking remote for latest version
    // if remote does not know about this id its probably draft so
    // local will return latest version
    if (!ref.isExact) {
      final latestVersion = await _remoteDocuments.getLatestVersion(ref.id);
      ref = ref.copyWith(ver: Optional(latestVersion));
    }

    final isCached = await _localDocuments.exists(id: ref);
    if (isCached) {
      return fromCache(ref);
    }

    final document = await _remoteDocuments.get(ref);

    if (document != null) {
      await _localDocuments.save(data: document);
    }

    return document != null ? fromDocument(document) : null;
  }

  Future<DocumentData?> _getSignedDocumentData({
    required SignedDocumentRef id,
  }) async {
    // if version is not specified we're asking remote for latest version.
    if (!id.isExact) {
      final latestVersion = await _remoteDocuments.getLatestVersion(id.id);
      id = id.copyWith(ver: Optional(latestVersion));
    }

    final isCached = await _localDocuments.exists(id: id);
    if (isCached) {
      return _localDocuments.get(id);
    }

    final document = await _remoteDocuments.get(id);

    if (document != null) {
      await _localDocuments.save(data: document);
    }

    return document;
  }

  bool _isDocumentMetadataValid(DocumentData document) {
    final template = document.metadata.template;
    final documentType = document.metadata.type;

    final isInvalidTemplate = template == null || !template.isValid;
    final isInvalidType = documentType == DocumentType.unknown;
    final isInvalidProposal = isInvalidTemplate || isInvalidType;

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
            'Invalid document metadata for document ${documentData.metadata.id}, skipping',
          );
          if (documentData.metadata.id is DraftRef) {
            unawaited(deleteDocumentDraft(id: documentData.metadata.id as DraftRef));
          }
          continue;
        }

        final templateRef = documentData.metadata.template!;
        final templateData = await _documentDataLock.synchronized(
          () => getDocumentData(id: templateRef),
        );
        results.add(
          DocumentsDataWithRefData(
            data: documentData,
            refData: templateData,
          ),
        );
      } catch (e, st) {
        _logger.warning('Error processing document ${documentData.metadata.id}', e, st);
        if (documentData.metadata.id is DraftRef) {
          unawaited(deleteDocumentDraft(id: documentData.metadata.id as DraftRef));
        }
        continue;
      }
    }

    return results;
  }

  void _validateDocumentMetadata(DocumentData document) {
    if (!_isDocumentMetadataValid(document)) {
      throw const DocumentImportInvalidDataException(DocumentMetadataMalformedException);
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
    return _drafts.watch(id: ref);
  }

  Stream<DocumentData?> _watchSignedDocumentData({
    required SignedDocumentRef ref,
    bool synchronizedUpdate = false,
  }) {
    /// Make sure we're up to date with document ref.
    final documentDataFuture = synchronizedUpdate
        // ignore: discarded_futures
        ? _documentDataLock.synchronized(() => getDocumentData(id: ref))
        // ignore: discarded_futures
        : getDocumentData(id: ref);

    final updateStream = Stream.fromFuture(documentDataFuture);
    final localStream = _localDocuments.watch(id: ref);

    return StreamGroup.merge([updateStream, localStream]);
  }
}
