part of 'proposal_cubit.dart';

/* cSpell:disable */

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

List<CommentWithReplies> _buildComments() {
  const uuid = Uuid();
  final now = DateTimeExt.now();

  SignedDocumentRef buildRefAt(DateTime dateTime) {
    final config = V7Options(dateTime.millisecondsSinceEpoch, null);
    final val = uuid.v7(config: config);
    return SignedDocumentRef.first(val);
  }

  final firstComment = _buildComment(
    message: 'The first rule about fight club is...',
    selfRef: buildRefAt(now),
  );
  return [
    CommentWithReplies(
      comment: firstComment,
      replies: [
        CommentWithReplies(
          comment: _buildComment(
            parent: firstComment.metadata.selfRef,
            message: 'Don’t talk about fight club',
            selfRef: buildRefAt(now.subtract(const Duration(hours: 2))),
          ),
          depth: 2,
        ),
        CommentWithReplies(
          comment: _buildComment(
            parent: firstComment.metadata.selfRef,
            message: 'Quiet!',
            selfRef: buildRefAt(now.subtract(const Duration(hours: 1))),
          ),
          depth: 2,
        ),
      ],
      depth: 1,
    ),
    CommentWithReplies.direct(
      _buildComment(
        message: 'This proposal embodies a bold and disruptive vision that '
            'aligns with the decentralised ethos of the Cardano ecosystem. '
            'The focus on empowering individuals through grassroots action '
            'and the inclusion of open-source methodologies makes it a '
            'transformative initiative. The clear milestones and emphasis '
            'on secure, replicable strategies inspire confidence in the '
            'project’s feasibility and scalability. I look forward to '
            'seeing its impact.',
        selfRef: buildRefAt(now.subtract(const Duration(hours: 5))),
      ),
    ),
  ];
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

/* cSpell:enable */
