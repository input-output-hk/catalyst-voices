import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Manage documents stored locally.
abstract interface class DocumentsService {
  const factory DocumentsService(
    DocumentRepository documentRepository,
  ) = DocumentsServiceImpl;

  /// Removes all locally stored documents.
  Future<int> clear();

  Future<bool> isFavorite(DocumentRef id);

  /// Returns all matching [DocumentData] for given [id].
  Future<List<DocumentData>> lookup(DocumentRef id);

  /// Emits change of documents count.
  Stream<int> watchCount();
}

final class DocumentsServiceImpl implements DocumentsService {
  final DocumentRepository _documentRepository;

  const DocumentsServiceImpl(
    this._documentRepository,
  );

  @override
  Future<int> clear() {
    return _documentRepository.removeAll();
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
  Stream<int> watchCount() {
    return _documentRepository.watchCount();
  }
}
