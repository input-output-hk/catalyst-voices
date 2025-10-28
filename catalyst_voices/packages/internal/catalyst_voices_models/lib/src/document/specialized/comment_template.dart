import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/document/document_metadata.dart';
import 'package:equatable/equatable.dart';

final class CommentTemplate extends Equatable {
  final CommentTemplateMetadata metadata;
  final DocumentSchema schema;

  const CommentTemplate({
    required this.metadata,
    required this.schema,
  });

  @override
  List<Object?> get props => [metadata, schema];
}

final class CommentTemplateMetadata extends DocumentMetadata {
  CommentTemplateMetadata({
    required SignedDocumentRef super.selfRef,
    required super.parameters,
  });
}
