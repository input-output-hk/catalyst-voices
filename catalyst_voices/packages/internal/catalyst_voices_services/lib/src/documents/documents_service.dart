import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:pool/pool.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('DocumentsService');

/// Manage documents stored locally.
abstract interface class DocumentsService {
  const factory DocumentsService(
    DocumentRepository documentRepository,
  ) = DocumentsServiceImpl;

  /// Removes all locally stored documents.
  ///
  /// if [keepLocalDrafts] is true local drafts and their templates will be kept.
  Future<int> clear({bool keepLocalDrafts});

  Future<bool> isFavorite(DocumentRef id);

  /// Returns all matching [DocumentData] for given [id].
  Future<List<DocumentData>> lookup(DocumentRef id);

  /// Syncs locally stored documents with api.
  ///
  /// Parameters:
  /// * [campaign] - used to sync documents only for it.
  /// * [onProgress] - emits from 0.0 to 1.0.
  /// * [maxConcurrent] - number of concurrent requests made at same time inside one batch.
  /// * [batchSize] - how many documents to request from the index in a single page.
  ///
  /// Returns [DocumentsSyncResult] with count of new and failed refs.
  Future<DocumentsSyncResult> sync({
    required Campaign campaign,
    ValueChanged<double>? onProgress,
    int maxConcurrent,
    int batchSize,
  });

  /// Emits change of documents count.
  Stream<int> watchCount();
}

final class DocumentsServiceImpl implements DocumentsService {
  final DocumentRepository _documentRepository;

  const DocumentsServiceImpl(
    this._documentRepository,
  );

  @override
  Future<int> clear({bool keepLocalDrafts = false}) {
    return _documentRepository.removeAll(keepLocalDrafts: keepLocalDrafts);
  }

  @override
  Future<bool> isFavorite(DocumentRef id) {
    return _documentRepository.isFavorite(id);
  }

  @override
  Future<List<DocumentData>> lookup(DocumentRef id) {
    return _documentRepository.findAllVersions(id: id);
  }

  @override
  Future<DocumentsSyncResult> sync({
    required Campaign campaign,
    ValueChanged<double>? onProgress,
    int maxConcurrent = 100,
    int batchSize = 300,
  }) async {
    _logger.finer('Indexing documents for f${campaign.fundNumber}');

    var syncResult = const DocumentsSyncResult();
    final categoriesIds = campaign.categories.map((e) => e.id.id).toSet().toList();

    // The sync process is ordered. Templates are synced first as other documents
    // may depend on them.
    final syncOrder = <DocumentType>[
      DocumentType.proposalTemplate,
      DocumentType.commentTemplate,
    ];

    // We perform one pass for each type in syncOrder, plus one final pass
    // for all remaining document types (when documentType is null).
    final totalSyncSteps = syncOrder.length + 1;
    final progressPerStep = 1 / totalSyncSteps;
    var completedSteps = 0;

    final pool = Pool(maxConcurrent);
    onProgress?.call(0);

    try {
      /// Synchronizing documents is done in certain order, according to [syncOrder]
      /// because some are more important then others and should be here first, like templates.
      /// Most of other docs refs to them.
      ///
      /// Doing it using such loop allows us to now have to query all cached documents for
      /// checking if something is cached or not.
      for (var stepIndex = 0; stepIndex < totalSyncSteps; stepIndex++) {
        final baseProgress = completedSteps * progressPerStep;

        // In the final pass, `documentType` will be null, which signals _sync
        // to handle all remaining documents not covered by the explicit syncOrder.
        final documentType = syncOrder.elementAtOrNull(stepIndex);
        final filters = DocumentIndexFilters(
          type: documentType != null ? [documentType] : null,
          categoriesIds: categoriesIds,
        );

        final result = await _sync(
          pool: pool,
          batchSize: batchSize,
          filters: filters,
          exclude: {
            // categories are not documents at the moment.
            DocumentBaseType.category,
          },
          excludeIds: _syncExcludeIds(
            syncOrder,
            documentType: documentType,
            // this should not be needed. Remove it later when categories are documents too
            // and we have no more const refs.
            additional: categoriesIds,
          ),
          onProgress: onProgress == null
              ? null
              : (value) {
                  final currentIterationProgress = value * progressPerStep;
                  final progress = baseProgress + currentIterationProgress;
                  onProgress(progress);
                },
        );

        completedSteps++;
        syncResult += result;
      }
    } finally {
      await pool.close();
      _logger.finer('Sync pool closed.');
      onProgress?.call(1);
    }

    // Analyze is kind of expensive so run it when significant amount of docs were added
    if (syncResult.newDocumentsCount > 100) {
      await _documentRepository.analyzeDatabase();
    }

    return syncResult;
  }

  @override
  Stream<int> watchCount() {
    return _documentRepository.watchCount();
  }

  /// Performs a paginated sync of documents based on the provided filters.
  ///
  /// This method iterates through pages of a document index, fetches the
  /// necessary documents, and saves them to the local repository. It is designed
  /// to handle large sets of documents by processing them in batches.
  ///
  /// - [pool]: A [Pool] to manage concurrent document fetching.
  /// - [batchSize]: The number of documents to request from the index in a
  ///   single page.
  /// - [filters]: [DocumentIndexFilters] to apply when querying the index.
  /// - [exclude]: A set of [DocumentBaseType]s to exclude from the sync.
  /// - [excludeIds]: A set of document IDs to explicitly exclude from the sync.
  /// - [onProgress]: An optional callback that reports the progress of the sync
  ///   operation as a value between 0.0 and 1.0.
  ///
  /// Returns a [DocumentsSyncResult] summarizing the number of new and failed
  /// documents synced during the operation.
  Future<DocumentsSyncResult> _sync({
    required Pool pool,
    required int batchSize,
    required DocumentIndexFilters filters,
    Set<DocumentBaseType> exclude = const {},
    Set<String> excludeIds = const {},
    ValueChanged<double>? onProgress,
  }) async {
    var page = 0;
    var remaining = 0;
    var result = const DocumentsSyncResult();

    onProgress?.call(0);

    do {
      final index = await _documentRepository.index(
        page: page,
        limit: batchSize,
        filters: filters,
      );

      final refs = await _syncFilterRefs(index, exclude, excludeIds);
      final results = await _syncGetDocuments(refs, pool);
      final syncResults = await _syncSaveBatchResults(results);

      result += syncResults;

      if (onProgress != null) {
        final completed = (page * index.page.limit) + index.docs.length;
        final total = completed + index.page.remaining;
        final progress = completed / total;

        onProgress.call(progress);
      }

      page = index.page.page + 1;
      remaining = index.page.remaining;
    } while (remaining > 0);

    onProgress?.call(1);

    return result;
  }

  /// Determines which document IDs to exclude from a sync operation based on the
  /// sync order and the current document type being processed.
  ///
  /// When syncing documents in a specific order (e.g., templates first), this
  /// method helps to exclude documents of types that are not yet supposed to be
  /// synced. This is particularly useful for excluding constant document
  /// references (like templates for proposals or comments) until it is their
  /// turn to be synced according to the [syncOrder].
  ///
  /// - [syncOrder]: The list defining the priority order for syncing document types.
  /// - [documentType]: The [DocumentType] currently being synced. If null, no
  ///   types from the `syncOrder` are excluded.
  /// - [additional]: A list of extra document IDs to add to the exclusion set.
  ///
  /// Returns a [Set] of document IDs that should be skipped in the current sync pass.
  Set<String> _syncExcludeIds(
    List<DocumentType> syncOrder, {
    DocumentType? documentType,
    List<String> additional = const [],
  }) {
    final excludedDocumentTypes = syncOrder.where((type) => type != documentType).toSet();
    final excludedConstIds = allConstantDocumentRefs
        .expand((element) => element.asMap().entries)
        .where((entry) => excludedDocumentTypes.contains(entry.key))
        .map((entry) => entry.value.id);

    return {
      ...additional,
      ...excludedConstIds,
    };
  }

  /// Takes a [DocumentIndex], extracts all document references from it,
  /// filters out any references that are already cached locally, and returns
  /// the list of non-cached [SignedDocumentRef]s.
  ///
  /// This is used to identify which documents need to be fetched from the
  /// remote repository during a sync operation.
  ///
  /// The [exclude] and [excludeIds] sets are used to further filter out
  /// references that should not be considered for syncing.
  Future<List<SignedDocumentRef>> _syncFilterRefs(
    DocumentIndex index,
    Set<DocumentBaseType> exclude,
    Set<String> excludeIds,
  ) async {
    final ids = index.docs
        .map((e) => e.refs(exclude: exclude))
        .expand((refs) => refs)
        .where((ref) => !excludeIds.contains(ref.id))
        .toSet()
        .toList();

    final cachedRefs = await _documentRepository.isCachedBulk(ids: ids);

    ids.removeWhere(cachedRefs.contains);

    return ids.toList();
  }

  /// Fetches the [DocumentDataWithArtifact] for a list of [SignedDocumentRef]s concurrently.
  ///
  /// This method takes a list of document references and uses a [Pool] to manage
  /// the concurrency of network requests, preventing resource exhaustion issues
  /// like `net::ERR_INSUFFICIENT_RESOURCES` in browsers when fetching a large
  /// number of documents simultaneously.
  ///
  /// Each fetch operation is wrapped in a [Result] type. This ensures that even
  /// if some requests fail, the overall process completes, and a list of all
  /// successes and failures can be returned for further processing.
  Future<List<Result<DocumentDataWithArtifact, RefSyncException>>> _syncGetDocuments(
    List<SignedDocumentRef> refs,
    Pool pool,
  ) {
    return refs.map(
      (ref) {
        return pool.withResource(() {
          return _documentRepository
              .getRemoteDocumentDataWithArtifact(id: ref)
              .then<Result<DocumentDataWithArtifact, RefSyncException>>(Success.new)
              .onError((error, stack) {
                return Failure(RefSyncException(ref, source: error));
              });
        });
      },
    ).wait;
  }

  /// Processes the results of fetching a batch of documents, saves the
  /// successful ones to the local repository, and returns a summary of the
  /// operation.
  ///
  /// This method takes a list of [Result] objects, where each object
  /// represents either a successfully fetched [DocumentData] or a
  /// [RefSyncException] for a failed fetch.
  ///
  /// It separates the successful fetches from the failures, saves all the
  /// successful documents in a single bulk operation, and then returns a
  /// [DocumentsSyncResult] that tallies the number of new and failed documents.
  Future<DocumentsSyncResult> _syncSaveBatchResults(
    List<Result<DocumentDataWithArtifact, RefSyncException>> results,
  ) async {
    final (List<DocumentDataWithArtifact> documents, int failures) = results.fold(
      (<DocumentDataWithArtifact>[], 0),
      (acc, result) {
        final (docs, failCount) = acc;
        if (result.isSuccess) {
          docs.add(result.success);
        }
        final failures = result.isFailure ? failCount + 1 : failCount;

        return (docs, failures);
      },
    );

    if (documents.isNotEmpty) {
      await _documentRepository.saveSignedDocumentBulk(documents);
    }

    return DocumentsSyncResult(
      newDocumentsCount: documents.length,
      failedDocumentsCount: failures,
    );
  }
}
