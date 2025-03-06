import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('DocumentsService');

typedef _RefFailure = Failure<SignedDocumentRef, Exception>;

typedef _RefSuccess = Success<SignedDocumentRef, Exception>;

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
  Future<List<SignedDocumentRef>> sync({
    ValueChanged<double>? onProgress,
  });
}

final class DocumentsServiceImpl implements DocumentsService {
  final DocumentRepository _documentRepository;

  DocumentsServiceImpl(
    this._documentRepository,
  );

  @override
  Future<List<SignedDocumentRef>> sync({
    ValueChanged<double>? onProgress,
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

    // Note. Handling or errors as Outcome because we have to
    // give a change to all refs to finish and keep all info about what
    // failed.
    final futures = <Future<Result<SignedDocumentRef, Exception>>>[
      for (final ref in missingRefs)
        _documentRepository
            .cacheDocument(ref: ref)
            .then<Result<SignedDocumentRef, Exception>>((_) => Success(ref))
            .catchError((Object error, StackTrace stackTrace) {
          final exception = RefSyncException(
            ref,
            error: error,
            stack: stackTrace,
          );
          return _RefFailure(exception);
        }).whenComplete(() {
          completed += 1;
          final progress = completed / total;
          final totalProgress = 0.2 + (progress * 0.8);
          onProgress?.call(totalProgress);
        }),
    ];

    final outcomes = await futures.wait;
    final failures = outcomes.whereType<_RefFailure>();

    if (failures.isNotEmpty) {
      final errors = failures.map((e) => e.failure).toList();
      throw RefsSyncException(errors);
    }

    onProgress?.call(1);

    return outcomes.whereType<_RefSuccess>().map((e) => e.success).toList();
  }
}
