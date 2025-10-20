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

  /// Returns all matching [DocumentData] for given [ref].
  Future<List<DocumentData>> lookup(DocumentRef ref);

  /// Syncs locally stored documents with api.
  ///
  /// Parameters:
  /// * [campaign] is used to sync documents only for it.
  /// * [onProgress] - emits from 0.0 to 1.0.
  /// * [maxConcurrent] - requests made at same time inside one batch
  /// * [batchSize] - how many documents per one batch
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
  Future<List<DocumentData>> lookup(DocumentRef ref) {
    return _documentRepository.getAllDocumentsData(ref: ref);
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
    final categoriesIds = campaign.categories.map((e) => e.selfRef.id).toSet().toList();

    // Later we'll change this list to include all templates,
    final syncOrder = <DocumentType>[
      DocumentType.proposalTemplate,
      DocumentType.commentTemplate,
    ];
    // +1 because i want last element to be null. Meaning index remaining types.
    final syncIterationsCount = syncOrder.length + 1;
    final progressPerIteration = 1 / syncIterationsCount;
    var completedIterations = 0;

    final pool = Pool(maxConcurrent);
    onProgress?.call(0);

    /// Synchronizing documents is done in certain order, according to [syncOrder]
    /// because some are more important then others and should be here first, like templates.
    /// Most of other docs refs to them.
    ///
    /// Doing it using such loop allows us to now have to query all cached documents for
    /// checking if something is cached or not.
    for (var i = 0; i < syncIterationsCount; i++) {
      final documentType = syncOrder.elementAtOrNull(i);
      final filters = DocumentIndexFilters(
        type: documentType,
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
        excludeIds: {
          // this should not be needed. Remove it later when categories are documents too
          // and we have no more const refs.
          ...categoriesIds,
          ...syncOrder
              .where((element) => element != documentType)
              .map(
                (excludedType) {
                  return allConstantDocumentRefs
                      .map(
                        (constRefs) {
                          return constRefs
                              .asMap()
                              .entries
                              .where((constRef) => constRef.key == excludedType)
                              .map((constRef) => constRef.value);
                        },
                      )
                      .expand((element) => element);
                },
              )
              .expand((element) => element.map((e) => e.id)),
        },
        onProgress: (value) {
          if (onProgress == null) {
            return;
          }

          /// Each iteration progress is counted equally
          final prevProgress = completedIterations * progressPerIteration;
          final curProgress = value * progressPerIteration;
          final progress = prevProgress + curProgress;
          onProgress.call(progress);
        },
      );

      completedIterations++;
      syncResult += result;
    }

    onProgress?.call(1);

    return syncResult;
  }

  @override
  Stream<int> watchCount() {
    return _documentRepository.watchCount();
  }

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
    var newDocumentsCount = 0;
    var failedDocumentsCount = 0;

    onProgress?.call(0);

    do {
      final index = await _documentRepository.index(
        page: page,
        limit: batchSize,
        filters: filters,
      );

      final refs = await index.docs
          .map((e) => e.refs(exclude: exclude))
          .expand((refs) => refs)
          .where((ref) => !excludeIds.contains(ref.id))
          .toSet()
          .map((ref) {
            return _documentRepository
                .isCached(ref: ref)
                .onError((_, _) => false)
                .then((value) => value ? null : ref);
          })
          .wait
          .then((refs) => refs.nonNulls.toList());

      final futures = refs.map(
        (ref) {
          /// Its possible that missingRefs can be very large
          /// and executing too many requests at once throws
          /// net::ERR_INSUFFICIENT_RESOURCES in chrome.
          /// That's reason for adding pool and limiting max requests.
          return pool.withResource(() {
            return _documentRepository
                .getDocumentData(ref: ref, useCache: false)
                .then<Result<DocumentData, RefSyncException>>(Success.new)
                /// Handling errors as Outcome because we have to
                /// give a change to all refs to finish and keep all info about what
                /// failed.
                .onError((error, stack) {
                  return Failure(RefSyncException(ref, source: error));
                });
          });
        },
      );

      final results = await Future.wait(futures);

      final documents = results
          .where((element) => element.isSuccess)
          .map((e) => e.success)
          .toList();

      await _documentRepository.saveDocumentBulk(documents);

      newDocumentsCount += documents.length;
      failedDocumentsCount += results.where((element) => element.isFailure).length;

      // Pages star from 0

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

    return DocumentsSyncResult(
      newDocumentsCount: newDocumentsCount,
      failedDocumentsCount: failedDocumentsCount,
    );
  }
}
