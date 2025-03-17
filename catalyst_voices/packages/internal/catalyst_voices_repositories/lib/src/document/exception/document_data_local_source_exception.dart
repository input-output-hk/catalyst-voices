import 'package:catalyst_voices_models/catalyst_voices_models.dart';

sealed class DocumentDataLocalSourceException implements Exception {
  const DocumentDataLocalSourceException();
}

final class DocumentNotFoundException extends DocumentDataLocalSourceException {
  final DocumentRef ref;

  const DocumentNotFoundException({required this.ref});

  @override
  String toString() => 'Document matching $ref not found';
}

final class DraftNotFoundException extends DocumentDataLocalSourceException {
  final DocumentRef ref;

  const DraftNotFoundException({required this.ref});

  @override
  String toString() => 'Draft matching $ref not found';
}
