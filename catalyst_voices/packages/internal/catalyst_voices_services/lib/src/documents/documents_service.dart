import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter/foundation.dart';

/// Manage documents stored locally.
abstract interface class DocumentsService {
  const factory DocumentsService(
    DocumentRepository documentRepository,
    DocumentsSynchronizer documentsSynchronizer,
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
  /// * [request] - used to sync documents for.
  /// * [onProgress] - emits from 0.0 to 1.0.
  /// * [maxConcurrent] - number of concurrent requests made at same time inside one batch.
  /// * [batchSize] - how many documents to request from the index in a single page.
  ///
  /// Returns [DocumentsSyncResult] with count of new and failed refs.
  Future<DocumentsSyncResult> sync(
    DocumentsSyncRequest request, {
    ValueChanged<double>? onProgress,
    int maxConcurrent,
    int batchSize,
  });

  /// Emits change of documents count.
  Stream<int> watchCount();
}

final class DocumentsServiceImpl implements DocumentsService {
  final DocumentRepository _documentRepository;
  final DocumentsSynchronizer _documentsSynchronizer;

  const DocumentsServiceImpl(
    this._documentRepository,
    this._documentsSynchronizer,
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
  Future<DocumentsSyncResult> sync(
    DocumentsSyncRequest request, {
    ValueChanged<double>? onProgress,
    int maxConcurrent = 100,
    int batchSize = 300,
  }) {
    return _documentsSynchronizer.start(
      request,
      onProgress: onProgress,
      maxConcurrent: maxConcurrent,
      batchSize: batchSize,
    );
  }

  @override
  Stream<int> watchCount() {
    return _documentRepository.watchCount();
  }
}
