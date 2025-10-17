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
  /// Returns count of new documents.
  Future<int> sync({
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
  Future<int> sync({
    required Campaign campaign,
    ValueChanged<double>? onProgress,
    int maxConcurrent = 100,
    int batchSize = 300,
  }) async {
    _logger.finer('Indexing documents for f${campaign.fundNumber}');

    onProgress?.call(0.1);

    // final allRefs = await _documentRepository.getAllDocumentsRefs();
    // final cachedRefs = await _documentRepository.getCachedDocumentsRefs();
    // final missingRefs = List.of(allRefs)..removeWhere(cachedRefs.contains);

    final refs = <DocumentRef>[];

    onProgress?.call(0.2);

    // debugPrint(
    //   'AllRefs[${allRefs.length}], '
    //   'CachedRefs[${cachedRefs.length}], '
    //   'MissingRefs[${missingRefs.length}]',
    // );

    if (refs.isEmpty) {
      onProgress?.call(1);
      return 0;
    }

    // refs.sort((a, b) => a.type.priority.compareTo(b.type.priority) * -1);

    final batches = refs.slices(batchSize);
    final batchesCount = batches.length;

    final pool = Pool(maxConcurrent);
    final errors = <RefSyncException>[];

    var batchesCompleted = 0;
    var documentsSynchronised = 0;

    for (final batch in batches) {
      final futures = [
        for (final value in batch)
          pool.withResource(
            () => _documentRepository
                .getDocumentData(ref: value, useCache: false)
                .then<Result<DocumentData, RefSyncException>>(Success.new)
                .onError(
                  (error, stackTrace) {
                    final syncError = RefSyncException(
                      value,
                      error: error,
                      stack: stackTrace,
                    );

                    return Failure(syncError);
                  },
                ),
          ),
      ];

      final results = await Future.wait(futures);

      final documents = results
          .where((element) => element.isSuccess)
          .map((e) => e.success)
          .toList();

      await _documentRepository.saveDocumentBulk(documents);

      documentsSynchronised += documents.length;

      final batchErrors = results
          .where((element) => element.isFailure)
          .map((e) => e.failure)
          .toList();

      errors.addAll(batchErrors);

      batchesCompleted += 1;
      final progress = batchesCompleted / batchesCount;
      final totalProgress = 0.2 + (progress * 0.6);
      onProgress?.call(totalProgress);
    }

    if (errors.isNotEmpty) {
      throw RefsSyncException(errors);
    }

    onProgress?.call(1);

    return documentsSynchronised;
  }

  @override
  Stream<int> watchCount() {
    return _documentRepository.watchCount();
  }
}
