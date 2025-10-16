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
  Future<int> clear();

  /// Returns all matching [DocumentData] for given [ref].
  Future<List<DocumentData>> lookup(DocumentRef ref);

  /// Syncs locally stored documents with api.
  ///
  /// Parameters:
  /// [onProgress] - emits from 0.0 to 1.0.
  /// [maxConcurrent] - requests made at same time inside one batch
  /// [batchSize] - how many documents per one batch
  ///
  /// Returns list of added refs.
  Future<List<TypedDocumentRef>> sync({
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
  Future<int> clear() => _documentRepository.removeAll();

  @override
  Future<List<DocumentData>> lookup(DocumentRef ref) {
    return _documentRepository.getAllDocumentsData(ref: ref);
  }

  @override
  Future<List<TypedDocumentRef>> sync({
    ValueChanged<double>? onProgress,
    int maxConcurrent = 100,
    int batchSize = 300,
  }) async {
    onProgress?.call(0.1);

    final allRefs = await _documentRepository.getAllDocumentsRefs();
    final cachedRefs = await _documentRepository.getCachedDocumentsRefs();
    final missingRefs = List.of(allRefs)..removeWhere(cachedRefs.contains);

    onProgress?.call(0.2);

    debugPrint(
      'AllRefs[${allRefs.length}], '
      'CachedRefs[${cachedRefs.length}], '
      'MissingRefs[${missingRefs.length}]',
    );

    if (missingRefs.isEmpty) {
      onProgress?.call(1);
      return [];
    }

    missingRefs.sort((a, b) => a.type.priority.compareTo(b.type.priority) * -1);

    final batches = missingRefs.slices(batchSize);
    final batchesCount = batches.length;
    var batchesCompleted = 0;

    final pool = Pool(maxConcurrent);
    final errors = <RefSyncException>[];

    for (final batch in batches) {
      final futures = batch.map<Future<Result<DocumentData, RefSyncException>>>(
        (value) {
          return pool.withResource(() async {
            try {
              final documentData = await _documentRepository.getDocumentData(ref: value.ref);

              return Success(documentData);
            } catch (error, stackTrace) {
              final syncError = RefSyncException(
                value.ref,
                error: error,
                stack: stackTrace,
              );
              return Failure(syncError);
            }
          });
        },
      );

      final results = await Future.wait(futures);

      final documents = results
          .where((element) => element.isSuccess)
          .map((e) => e.success)
          .toList();

      await _documentRepository.saveDocumentBulk(documents);

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

    return List.empty();
  }

  @override
  Stream<int> watchCount() {
    return _documentRepository.watchCount();
  }
}
