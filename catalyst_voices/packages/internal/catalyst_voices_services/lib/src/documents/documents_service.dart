import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

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
    yield 0.5;

    await Future<void>.delayed(const Duration(seconds: 1));

    yield 1;
  }
}
