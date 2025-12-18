import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class CommentTemplateNotFoundException implements DocumentException {
  final DocumentRef category;

  const CommentTemplateNotFoundException({required this.category});

  @override
  String toString() => 'Comment template for category $category not found';
}

/// Base class for all document exceptions.
sealed class DocumentException implements Exception {}

/// Exception thrown when signed document metadata is malformed.
final class DocumentMetadataMalformedException implements DocumentException {
  final List<String> reasons;

  const DocumentMetadataMalformedException({required this.reasons});

  @override
  String toString() => 'SignedDocument malformed because of $reasons';
}

/// Exception thrown when document is not found.
final class DocumentNotFoundException implements DocumentException {
  final DocumentRef ref;

  const DocumentNotFoundException({required this.ref});

  @override
  String toString() => 'Document matching $ref not found';
}

/// Exception thrown when draft is not found.
final class DraftNotFoundException implements DocumentException {
  final DocumentRef ref;

  const DraftNotFoundException({required this.ref});

  @override
  String toString() => 'Draft matching $ref not found';
}

final class ProposalTemplateNotFoundException implements DocumentException {
  final DocumentRef category;

  const ProposalTemplateNotFoundException({required this.category});

  @override
  String toString() => 'Proposal template for category $category not found';
}

/// Exception thrown when signed document content type is unknown.
final class UnknownDocumentContentTypeException implements DocumentException {
  final DocumentContentType type;

  const UnknownDocumentContentTypeException({required this.type});

  @override
  String toString() => 'Unknown Document contentType($type)';
}
