import 'package:catalyst_voices_models/catalyst_voices_models.dart';

sealed class DocumentDataLocalSourceException implements Exception {
  const DocumentDataLocalSourceException();
}

final class DocumentNotFound extends DocumentDataLocalSourceException {
  final DocumentRef ref;

  DocumentNotFound({required this.ref});

  @override
  String toString() => 'Document matching $ref not found';
}

final class DraftNotFound extends DocumentDataLocalSourceException {
  final DocumentRef ref;

  DraftNotFound({required this.ref});

  @override
  String toString() => 'Draft matching $ref not found';
}
