part of 'proposal_cubit.dart';

// TODO(damian-molinski): delete this after integration.
CommentDocument _buildComment({
  SignedDocumentRef? selfRef,
  SignedDocumentRef? parent,
  String? message,
}) {
  final commentTemplate = _buildSchema();

  final builder = DocumentBuilder.fromSchema(schema: commentTemplate);

  if (message != null) {
    final change = DocumentValueChange(
      nodeId: DocumentNodeId.fromString('comment.content'),
      value: message,
    );
    builder.addChange(change);
  }

  final document = builder.build();

  return CommentDocument(
    metadata: CommentMetadata(
      selfRef: selfRef ?? SignedDocumentRef.generateFirstRef(),
      parent: parent,
    ),
    document: document,
  );
}

CommentTemplate _buildCommentTemplate() {
  final schema = _buildSchema();

  final document = DocumentBuilder.fromSchema(schema: schema).build();

  return CommentTemplate(
    metadata: CommentTemplateMetadata(
      selfRef: SignedDocumentRef.generateFirstRef(),
    ),
    document: document,
  );
}

DocumentSchema _buildSchema() {
  return DocumentSchema.optional(
    properties: [
      DocumentGenericObjectSchema.optional(
        nodeId: DocumentNodeId.fromString('comment'),
        description: const MarkdownData('The comments on the proposal'),
        properties: [
          DocumentMultiLineTextEntrySchema.optional(
            nodeId: DocumentNodeId.fromString('comment.content'),
            description: const MarkdownData('The comment text content'),
            strLengthRange: const Range(min: 1, max: 5000),
            isRequired: true,
          ),
        ],
      ),
    ],
  );
}
