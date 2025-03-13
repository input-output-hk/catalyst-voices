import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
  final String message;

  const CommentListItem({
    required this.id,
    required this.message,
  });

  @override
  List<Object?> get props => [id, message];
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
    required List<String> comments,
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
  final List<String> comments;

  const ViewCommentsSection({
    required super.id,
    required this.comments,
  });

  @override
  Iterable<SegmentsListViewItem> get children => comments.map((e) {
        return CommentListItem(
          id: NodeId('${id.value}.$e'),
          message: e,
        );
      });

  @override
  List<Object?> get props => super.props + [comments];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewViewCommentsSection;
  }
}
