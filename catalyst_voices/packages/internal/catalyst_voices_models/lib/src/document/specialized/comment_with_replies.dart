import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CommentWithReplies extends Equatable {
  final CommentDocument comment;
  final List<CommentWithReplies> replies;
  final int depth;

  const CommentWithReplies({
    required this.comment,
    this.replies = const [],
    this.depth = 1,
  });

  const CommentWithReplies.direct(this.comment)
      : replies = const [],
        depth = 1;

  SignedDocumentRef get ref => comment.metadata.selfRef;

  @override
  List<Object?> get props => [
        comment,
        replies,
        depth,
      ];

  CommentWithReplies addReply(CommentDocument reply) {
    final parent = reply.metadata.parent;
    assert(parent != null, 'Invalid reply');

    if (isA(parent!)) {
      return _addReply(reply);
    }

    final replies = List.of(this.replies)
        .map((comment) => comment.addReply(reply))
        .toList();

    return copyWith(replies: replies);
  }

  bool contains(SignedDocumentRef ref) {
    return isA(ref) || replies.any((reply) => reply.isA(ref));
  }

  CommentWithReplies copyWith({
    CommentDocument? comment,
    List<CommentWithReplies>? replies,
    int? depth,
  }) {
    return CommentWithReplies(
      comment: comment ?? this.comment,
      replies: replies ?? this.replies,
      depth: depth ?? this.depth,
    );
  }

  bool isA(SignedDocumentRef ref) => comment.metadata.selfRef == ref;

  CommentWithReplies _addReply(CommentDocument reply) {
    assert(
      comment.metadata.selfRef == reply.metadata.parent,
      'Reply parent ref does not match with comment selfRef',
    );

    final commentWithReplies = CommentWithReplies(
      comment: reply,
      depth: depth + 1,
    );

    final replies = List.of(this.replies)..add(commentWithReplies);

    return copyWith(replies: replies);
  }
}
