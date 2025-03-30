import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class AddCommentSection extends CommentsSection {
  final DocumentSchema schema;

  const AddCommentSection({
    required super.id,
    required this.schema,
  });

  @override
  List<Object?> get props => super.props + [schema];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.addCommentSection;
  }
}

final class CommentListItem extends Equatable implements SegmentsListViewItem {
  @override
  final NodeId id;
  final CommentWithReplies comment;
  final bool canReply;

  const CommentListItem({
    required this.id,
    required this.comment,
    required this.canReply,
  });

  @override
  List<Object?> get props => [
        id,
        comment,
        canReply,
      ];
}

sealed class CommentsSection extends BaseSection {
  const CommentsSection({
    required super.id,
  });
}

final class CommentsSegment extends BaseSegment<CommentsSection> {
  final CommentsSort sort;

  const CommentsSegment({
    required super.id,
    required this.sort,
    required super.sections,
  });

  bool get hasComments => sections
      .whereType<ViewCommentsSection>()
      .any((element) => element.comments.isNotEmpty);

  @override
  SvgGenImage get icon => VoicesAssets.icons.chatAlt2;

  @override
  List<Object?> get props => super.props + [sort];

  CommentsSegment copySorted({
    required CommentsSort sort,
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

  CommentsSegment copyWith({
    NodeId? id,
    CommentsSort? sort,
    List<CommentsSection>? sections,
  }) {
    return CommentsSegment(
      id: id ?? this.id,
      sort: sort ?? this.sort,
      sections: sections ?? this.sections,
    );
  }

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.commentsSegment;
  }
}

final class ViewCommentsSection extends CommentsSection
    implements SegmentGroupedListViewItems {
  final List<CommentWithReplies> comments;
  final bool canReply;

  const ViewCommentsSection({
    required super.id,
    required this.comments,
    required this.canReply,
  });

  @override
  Iterable<SegmentsListViewItem> get children {
    return comments.mapIndexed((index, comment) {
      return CommentListItem(
        id: id.child(comment.comment.metadata.selfRef.id),
        comment: comment,
        canReply: canReply,
      );
    });
  }

  @override
  List<Object?> get props => super.props + [comments, canReply];

  ViewCommentsSection copyWith({
    NodeId? id,
    List<CommentWithReplies>? comments,
    bool? canReply,
  }) {
    return ViewCommentsSection(
      id: id ?? this.id,
      comments: comments ?? this.comments,
      canReply: canReply ?? this.canReply,
    );
  }

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.viewCommentsSection;
  }
}
