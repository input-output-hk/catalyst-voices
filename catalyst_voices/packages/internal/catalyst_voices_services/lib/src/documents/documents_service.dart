import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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

    final syncOrder = <DocumentType?>[
      DocumentType.proposalTemplate,
      DocumentType.commentTemplate,
      null,
    ];

    final pool = Pool(maxConcurrent);
    for (var i = 0; i < syncOrder.length; i++) {
      final documentType = syncOrder[i];
      final filters = DocumentIndexFilters(
        type: documentType,
        categoriesIds: categoriesIds,
      );

      final result = await _sync(
        pool: pool,
        batchSize: batchSize,
        filters: filters,
        skip: categoriesIds,
        onProgressChanged: (value) {
          onProgress?.call(value * i / syncOrder.length);
        },
      );

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
    List<String> skip = const [],
    ValueChanged<double>? onProgressChanged,
  }) async {
    var page = 0;
    var remaining = 0;
    var newDocumentsCount = 0;
    var failedDocumentsCount = 0;

    do {
      final index = await _documentRepository.index(
        page: page,
        limit: batchSize,
        filters: filters,
      );

      final missingRefs = <SignedDocumentRef>[];

      for (final ref in index.refs) {
        final isSkipped = skip.contains(ref.id);
        if (isSkipped) continue;

        final isCached = await _documentRepository.isCached(ref: ref);
        if (!isCached) {
          missingRefs.add(ref);
        }
      }

      final futures = missingRefs.map(
        (ref) {
          return pool.withResource(() {
            return _documentRepository
                .getDocumentData(ref: ref, useCache: false)
                .then<Result<DocumentData, RefSyncException>>(Success.new)
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
      final completed = page + 1 * index.page.limit;
      final total = completed + index.page.remaining;
      final progress = completed / total;

      onProgressChanged?.call(progress);

      page = index.page.page + 1;
      remaining = index.page.remaining;
    } while (remaining > 0);

    return DocumentsSyncResult(
      newDocumentsCount: newDocumentsCount,
      failedDocumentsCount: failedDocumentsCount,
    );
  }
}
