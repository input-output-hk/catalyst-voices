import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class CommentService {
  /// [CommentTemplate] is connected to category.
  Future<CommentTemplate> getCommentTemplateFor({
    required SignedDocumentRef category,
  });

  /// Send new comment.
  ///
  /// [data] body of comment itself.
  ///
  /// [ref] is document ref that this comment refers to. Comment can not
  /// exist on its own but just in a context of other documents.
  ///
  /// [reply] equals other comment of this is a reply to it.
  ///
  /// Returns [SignedDocumentRef] to newly created document.
  Future<SignedDocumentRef> submitComment({
    required DocumentData data,
    required DocumentRef ref,
    SignedDocumentRef? reply,
  });

  /// Emits list of comment which are matching [ref].
  ///
  /// See [submitComment] for more context.
  Stream<List<CommentDocument>> watchCommentsWith({
    required DocumentRef ref,
  });
}

final class CommentServiceImpl implements CommentService {
  @override
  Future<CommentTemplate> getCommentTemplateFor({
    required SignedDocumentRef category,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SignedDocumentRef> submitComment({
    required DocumentData data,
    required DocumentRef ref,
    SignedDocumentRef? reply,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<CommentDocument>> watchCommentsWith({required DocumentRef ref}) {
    throw UnimplementedError();
  }
}
