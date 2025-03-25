import 'package:catalyst_voices_models/catalyst_voices_models.dart';

sealed class DocumentException implements Exception {}

final class DocumentNotFoundException implements DocumentException {
  final DocumentRef ref;

  const DocumentNotFoundException({required this.ref});

  @override
  String toString() => 'Document matching $ref not found';
}

final class DraftNotFoundException implements DocumentException {
  final DocumentRef ref;

  const DraftNotFoundException({required this.ref});

  @override
  String toString() => 'Draft matching $ref not found';
}

final class SignedDocumentMetadataMalformed implements DocumentException {
  final List<String> reasons;

  const SignedDocumentMetadataMalformed({required this.reasons});

  @override
  String toString() => 'SignedDocument malformed because of $reasons';
}

final class UnknownSignedDocumentContentType implements DocumentException {
  final SignedDocumentContentType type;

  const UnknownSignedDocumentContentType({required this.type});

  @override
  String toString() => 'Unknown SignedDocument contentType($type)';
}
