import 'dart:async';

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final _logger = Logger('DocumentsService');

// ignore: one_member_abstracts
abstract interface class DocumentsService {
  factory DocumentsService(
    DocumentRepository documentRepository,
  ) = DocumentsServiceImpl;

  /// Syncs locally stored documents with api.
  ///
  /// Emits process from 0.0 to 1.0.
  Stream<double> sync();
}

final class DocumentsServiceImpl implements DocumentsService {
  final DocumentRepository _documentRepository;

  DocumentsServiceImpl(
    this._documentRepository,
  );

  @override
  Stream<double> sync() async* {
    yield 0.1;

    final allRefs = await _documentRepository.getAllDocumentsRefs();
    final cachedRefs = await _documentRepository.getCachedDocumentsRefs();
    final missingRefs = List.of(allRefs)..removeWhere(cachedRefs.contains);

    _logger.finest(
      'AllRefs[${allRefs.length}], '
      'CachedRefs[${cachedRefs.length}], '
      'MissingRefs[${missingRefs.length}]',
    );

    yield 0.2;

    var cachedCount = 0;
    final cacheProgressSC = StreamController<double>();

    final docsCacheFutures = [
      for (final ref in missingRefs)
        _documentRepository
            .cacheDocument(ref: ref)
            .then((_) => ref)
            .whenComplete(() {
          cachedCount += 1;

          final progress = cachedCount / missingRefs.length;
          cacheProgressSC.add(progress);
        }),
    ];

    final completeFuture = docsCacheFutures.wait.whenComplete(() async {
      await cacheProgressSC.close();
    });

    yield* cacheProgressSC.stream
        .map((progress) => 0.8 * progress)
        .map((progress) => 0.2 + progress);

    final successRefs = await completeFuture;
    final failedRefs = List.of(missingRefs)..removeWhere(successRefs.contains);

    if (failedRefs.isNotEmpty) {
      _logger
        ..severe('Failed to sync ${failedRefs.length} refs')
        ..finest('Failed refs: $failedRefs');
    }

    yield 1.0;
  }
}
