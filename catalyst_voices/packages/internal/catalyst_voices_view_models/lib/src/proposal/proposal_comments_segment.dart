import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class AddCommentSection extends ProposalCommentsSection {
  const AddCommentSection({
    required super.id,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewAddCommentSection;
  }
}

final class CommentListItem extends Equatable implements SegmentsListViewItem {
  @override
  final NodeId id;
  final CommentWithReplies comment;

  const CommentListItem({
    required this.id,
    required this.comment,
  });

  @override
  List<Object?> get props => [id, comment];
}

sealed class ProposalCommentsSection extends BaseSection {
  const ProposalCommentsSection({
    required super.id,
  });
}

final class ProposalCommentsSegment
    extends BaseSegment<ProposalCommentsSection> {
  const ProposalCommentsSegment({
    required super.id,
    required super.sections,
  });

  ProposalCommentsSegment.build({
    required List<CommentWithReplies> comments,
  }) : this(
          id: const NodeId('comments'),
          sections: [
            ViewCommentsSection(
              id: const NodeId('comments.view'),
              comments: comments,
            ),
            const AddCommentSection(id: NodeId('comments.add')),
          ],
        );

  @override
  SvgGenImage get icon => VoicesAssets.icons.chatAlt2;

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewCommentsSegment;
  }
}

final class ViewCommentsSection extends ProposalCommentsSection
    implements SegmentGroupedListViewItems {
  final List<CommentWithReplies> comments;

  const ViewCommentsSection({
    required super.id,
    required this.comments,
  });

  @override
  Iterable<SegmentsListViewItem> get children {
    return comments.mapIndexed((index, comment) {
      return CommentListItem(
        id: id.child(comment.comment.metadata.selfRef.id),
        comment: comment,
      );
    });
  }

  @override
  List<Object?> get props => super.props + [comments];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewViewCommentsSection;
  }
}
