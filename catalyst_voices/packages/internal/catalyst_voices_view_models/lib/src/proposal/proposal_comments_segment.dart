import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class AddCommentSection extends ProposalCommentsSection {
  final DocumentSchema schema;

  const AddCommentSection({
    required super.id,
    required this.schema,
  });

  @override
  List<Object?> get props => super.props + [schema];

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
  final ProposalCommentsSort sort;

  const ProposalCommentsSegment({
    required super.id,
    required this.sort,
    required super.sections,
  });

  ProposalCommentsSegment.build({
    required ProposalCommentsSort sort,
    required DocumentSchema commentSchema,
    required List<CommentWithReplies> comments,
  }) : this(
          id: const NodeId('comments'),
          sort: sort,
          sections: [
            ViewCommentsSection(
              id: const NodeId('comments.view'),
              comments: comments,
            ),
            AddCommentSection(
              id: const NodeId('comments.add'),
              schema: commentSchema,
            ),
          ],
        );

  @override
  SvgGenImage get icon => VoicesAssets.icons.chatAlt2;

  @override
  List<Object?> get props => super.props + [sort];

  ProposalCommentsSegment copySorted({
    required ProposalCommentsSort sort,
  }) {
    final sortedSection = sections.map((section) {
      return switch (section) {
        AddCommentSection() => section,
        ViewCommentsSection() => section.copyWith(
            comments: sort.applyTo(section.comments),
          ),
      };
    }).toList();

    return copyWith(
      sort: sort,
      sections: sortedSection,
    );
  }

  ProposalCommentsSegment copyWith({
    NodeId? id,
    ProposalCommentsSort? sort,
    List<ProposalCommentsSection>? sections,
  }) {
    return ProposalCommentsSegment(
      id: id ?? this.id,
      sort: sort ?? this.sort,
      sections: sections ?? this.sections,
    );
  }

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

  ViewCommentsSection copyWith({
    NodeId? id,
    List<CommentWithReplies>? comments,
  }) {
    return ViewCommentsSection(
      id: id ?? this.id,
      comments: comments ?? this.comments,
    );
  }

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.proposalViewViewCommentsSection;
  }
}
