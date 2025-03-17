import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CommentWithReplies extends Equatable {
  final CommentDocument comment;
  final List<CommentWithReplies> replies;
  final int depth;

  const CommentWithReplies({
    required this.comment,
    required this.replies,
    required this.depth,
  });

  @override
  List<Object?> get props => [
        comment,
        replies,
        depth,
      ];
}
