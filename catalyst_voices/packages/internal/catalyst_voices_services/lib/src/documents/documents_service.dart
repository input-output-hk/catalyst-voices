import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:pool/pool.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('DocumentsService');

typedef _RefFailure = Failure<TypedDocumentRef, Exception>;

typedef _RefSuccess = Success<TypedDocumentRef, Exception>;

// ignore: one_member_abstracts
abstract interface class DocumentsService {
  factory DocumentsService(
    DocumentRepository documentRepository,
  ) = DocumentsServiceImpl;

  /// Syncs locally stored documents with api.
  ///
  /// [onProgress] emits from 0.0 to 1.0.
  ///
  /// Returns list of added refs.
  Future<List<TypedDocumentRef>> sync({
    ValueChanged<double>? onProgress,
    int maxConcurrent,
  });
}

final class DocumentsServiceImpl implements DocumentsService {
  final DocumentRepository _documentRepository;

  DocumentsServiceImpl(
    this._documentRepository,
  );

  @override
  Future<List<TypedDocumentRef>> sync({
    ValueChanged<double>? onProgress,
    int maxConcurrent = 100,
  }) async {
    onProgress?.call(0.1);

    final allRefs = await _documentRepository.getAllDocumentsRefs();
    final cachedRefs = await _documentRepository.getCachedDocumentsRefs();
    final missingRefs = List.of(allRefs)..removeWhere(cachedRefs.contains);

    _logger.finest(
      'AllRefs[${allRefs.length}], '
      'CachedRefs[${cachedRefs.length}], '
      'MissingRefs[${missingRefs.length}]',
    );

    if (missingRefs.isEmpty) {
      onProgress?.call(1);
      return [];
    }

    onProgress?.call(0.2);

    var completed = 0;
    final total = missingRefs.length;
    final pool = Pool(maxConcurrent);

    final outcomes = <Result<TypedDocumentRef, Exception>>[];

    final prioritizedMissingRefs = missingRefs
        .groupListsBy((element) => element.type.priority)
        .entries
        .sorted((a, b) => a.key.compareTo(b.key) * -1);

    _logger.finest(
      prioritizedMissingRefs
          .map((e) => 'Priority[${e.key}] group refs[${e.value.length}]')
          .join('\n'),
    );

    /// Prioritize documents synchronization because
    /// some documents depend on other already beaning available.
    ///
    /// One such case is Proposal and Template or Action.
    for (final group in prioritizedMissingRefs) {
      _logger.finest(
        'Syncing priority[${group.key}] '
        'group with refs[${group.value.length}]',
      );
      final futures = <Future<void>>[];

      /// Handling or errors as Outcome because we have to
      /// give a change to all refs to finish and keep all info about what
      /// failed.
      for (final ref in group.value) {
        /// Its possible that missingRefs can be very large
        /// and executing too many requests at once throws
        /// net::ERR_INSUFFICIENT_RESOURCES in chrome.
        /// That's reason for adding pool and limiting max requests.
        final future = pool.withResource<void>(() async {
          try {
            if (ref.ref is SignedDocumentRef) {
              final signedRef = ref.ref.toSignedDocumentRef();
              await _documentRepository.cacheDocument(ref: signedRef);
            }
            outcomes.add(_RefSuccess(ref));
          } catch (error, stackTrace) {
            final exception = RefSyncException(
              ref.ref,
              error: error,
              stack: stackTrace,
            );
            outcomes.add(_RefFailure(exception));
          } finally {
            completed += 1;
            final progress = completed / total;
            final totalProgress = 0.2 + (progress * 0.8);
            onProgress?.call(totalProgress);
          }
        });

        futures.add(future);
      }

      // Wait for all operations managed by the pool to complete
      await Future.wait(futures);
    }

    final failures = outcomes.whereType<_RefFailure>();

    if (failures.isNotEmpty) {
      final errors = failures.map((e) => e.failure).toList();
      throw RefsSyncException(errors);
    }

    onProgress?.call(1);

    return outcomes.whereType<_RefSuccess>().map((e) => e.success).toList();
  }
}
