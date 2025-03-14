import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CommentWithReplies extends Equatable {
  final CommentDocument comment;
  final List<CommentWithReplies> replies;

  const CommentWithReplies({
    required this.comment,
    required this.replies,
  });

  @override
  List<Object?> get props => [comment, replies];
}
