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

  factory CommentWithReplies.build(
    CommentDocument comment, {
    required List<CommentDocument> comments,
    int depth = 1,
  }) {
    final replies = comments.where((element) => element.metadata.reply == comment.metadata.id).map((
      e,
    ) {
      return CommentWithReplies.build(
        e,
        comments: comments,
        depth: depth + 1,
      );
    }).toList();

    return CommentWithReplies(
      comment: comment,
      replies: replies,
      depth: depth,
    );
  }

  const CommentWithReplies.direct(this.comment) : replies = const [], depth = 1;

  @override
  List<Object?> get props => [
    comment,
    replies,
    depth,
  ];

  SignedDocumentRef get ref => comment.metadata.id;

  int get repliesCount {
    return replies.fold(
      0,
      (previousValue, element) => previousValue + 1 + element.repliesCount,
    );
  }

  CommentWithReplies addReply(CommentDocument reply) {
    final parent = reply.metadata.reply;
    assert(parent != null, 'Invalid reply');

    if (isA(parent!)) {
      return _addReply(reply);
    }

    final replies = List.of(this.replies).map((comment) => comment.addReply(reply)).toList();

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

  bool isA(SignedDocumentRef ref) => comment.metadata.id == ref;

  CommentWithReplies removeReply({
    required SignedDocumentRef ref,
  }) {
    final replies = List.of(this.replies).map((e) => e.removeReply(ref: ref)).toList()
      ..removeWhere((element) => element.ref == ref);

    return copyWith(replies: replies);
  }

  CommentWithReplies _addReply(CommentDocument reply) {
    assert(
      comment.metadata.id == reply.metadata.reply,
      'Reply parent ref does not match with comment id',
    );

    final commentWithReplies = CommentWithReplies(
      comment: reply,
      depth: depth + 1,
    );

    final replies = List.of(this.replies)..add(commentWithReplies);

    return copyWith(replies: replies);
  }
}

extension CommentWithRepliesListExt on List<CommentWithReplies> {
  List<CommentWithReplies> addComment({
    required CommentDocument comment,
  }) {
    final comments = List.of(this);
    final reply = comment.metadata.reply;

    if (reply != null) {
      final index = comments.indexWhere((comment) => comment.contains(reply));
      if (index != -1) {
        final updated = comments.removeAt(index).addReply(comment);
        comments.insert(index, updated);
      }
    } else {
      comments.add(CommentWithReplies.direct(comment));
    }

    return comments;
  }

  List<CommentWithReplies> removeComment({
    required SignedDocumentRef ref,
  }) {
    return List.of(this).where((e) => e.ref != ref).map((e) => e.removeReply(ref: ref)).toList();
  }
}
