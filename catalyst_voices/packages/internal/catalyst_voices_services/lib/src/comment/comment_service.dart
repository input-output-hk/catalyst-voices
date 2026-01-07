import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

/// CommentService provides comment-related functionality.
///
/// [CommentRepository] is used to get the comment data.
/// [SignerService] is used to sign the comment.
abstract interface class CommentService {
  const factory CommentService(
    CommentRepository commentRepository,
    SignerService signerService,
  ) = CommentServiceImpl;

  /// [CommentTemplate] is connected to category.
  Future<CommentTemplate> getCommentTemplate({
    required DocumentRef category,
  });

  /// Send new comment.
  ///
  /// [document] body of comment itself.
  Future<SignedDocumentRef> submitComment({
    required DocumentData document,
  });

  /// Emits list of comment which are matching [ref].
  ///
  /// See [submitComment] for more context.
  Stream<List<CommentWithReplies>> watchCommentsWith({
    required DocumentRef ref,
  });
}

final class CommentServiceImpl implements CommentService {
  final CommentRepository _commentRepository;
  final SignerService _signerService;

  const CommentServiceImpl(
    this._commentRepository,
    this._signerService,
  );

  @override
  Future<CommentTemplate> getCommentTemplate({
    required DocumentRef category,
  }) async {
    final template = await _commentRepository.getCommentTemplate(category: category);
    if (template == null) {
      throw CommentTemplateNotFoundException(category: category);
    }

    return template;
  }

  @override
  Future<SignedDocumentRef> submitComment({
    required DocumentData document,
  }) async {
    if (document.metadata.selfRef is! SignedDocumentRef) {
      throw ArgumentError('Drafts not supported for comments');
    }

    await _signerService.useVoterCredentials((catalystId, privateKey) {
      return _commentRepository.publishComment(
        document: document,
        catalystId: catalystId,
        privateKey: privateKey,
      );
    });

    await _commentRepository.saveComment(document: document);

    return document.ref as SignedDocumentRef;
  }

  @override
  Stream<List<CommentWithReplies>> watchCommentsWith({
    required DocumentRef ref,
  }) {
    assert(ref.isExact, 'Comments are linked to exact version of document');

    return _commentRepository.watchCommentsWith(ref: ref).map(_buildCommentTree);
  }

  List<CommentWithReplies> _buildCommentTree(List<CommentDocument> comments) {
    return comments
        .where((element) => element.metadata.reply == null)
        .map((e) => CommentWithReplies.build(e, comments: comments))
        .toList();
  }
}
