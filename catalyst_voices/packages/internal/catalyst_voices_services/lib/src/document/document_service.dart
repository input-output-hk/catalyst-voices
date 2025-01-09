import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class DocumentService {
  factory DocumentService(
    DocumentRepository documentRepository,
  ) = DocumentServiceImpl;

  Future<void> publishDocument(Document document);

  Future<Document> getDocument(String id);
}

final class DocumentServiceImpl implements DocumentService {
  final DocumentRepository _documentRepository;

  const DocumentServiceImpl(
    this._documentRepository,
  );

  @override
  Future<Document> getDocument(String id) {
    return _documentRepository.getDocument(id);
  }

  @override
  Future<void> publishDocument(Document document) {
    return _documentRepository.publishDocument(document);
  }
}
