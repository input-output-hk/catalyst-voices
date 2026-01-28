import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Section for adding a comment to a proposal
final class DocumentAddCommentSection extends DocumentCommentsSection {
  final DocumentSchema schema;
  final bool showUsernameRequired;

  const DocumentAddCommentSection({
    required super.id,
    required this.schema,
    required this.showUsernameRequired,
  });

  @override
  List<Object?> get props =>
      super.props +
      [
        schema,
        showUsernameRequired,
      ];

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.addCommentSection;
  }
}

/// List item for a comment in a proposal
final class DocumentCommentListItem extends Equatable implements SegmentsListViewItem {
  @override
  final NodeId id;
  final CommentWithReplies comment;
  final bool canReply;

  const DocumentCommentListItem({
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

/// Section for comments in a proposal
sealed class DocumentCommentsSection extends BaseSection {
  const DocumentCommentsSection({
    required super.id,
  });
}

/// Segment for comments in a proposal
final class DocumentCommentsSegment extends BaseSegment<DocumentCommentsSection> {
  final DocumentCommentsSort sort;

  const DocumentCommentsSegment({
    required super.id,
    required this.sort,
    required super.sections,
  });

  bool get hasComments => sections.whereType<DocumentViewCommentsSection>().any(
    (element) => element.comments.isNotEmpty,
  );

  @override
  SvgGenImage get icon => VoicesAssets.icons.chatAlt2;

  @override
  List<Object?> get props => super.props + [sort];

  DocumentCommentsSegment copySorted({
    required DocumentCommentsSort sort,
  }) {
    final sortedSection = sections.map((section) {
      return switch (section) {
        DocumentAddCommentSection() => section,
        DocumentViewCommentsSection() => section.copyWith(
          comments: sort.applyTo(section.comments),
        ),
      };
    }).toList();

    return copyWith(
      sort: sort,
      sections: sortedSection,
    );
  }

  DocumentCommentsSegment copyWith({
    NodeId? id,
    DocumentCommentsSort? sort,
    List<DocumentCommentsSection>? sections,
  }) {
    return DocumentCommentsSegment(
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

/// Section for viewing comments in a proposal
final class DocumentViewCommentsSection extends DocumentCommentsSection
    implements SegmentGroupedListViewItems {
  final DocumentCommentsSort sort;
  final List<CommentWithReplies> comments;
  final bool canReply;

  const DocumentViewCommentsSection({
    required super.id,
    required this.sort,
    required this.comments,
    required this.canReply,
  });

  @override
  Iterable<SegmentsListViewItem> get children {
    return comments.mapIndexed((index, comment) {
      return DocumentCommentListItem(
        id: id.child(comment.comment.metadata.id.id),
        comment: comment,
        canReply: canReply,
      );
    });
  }

  @override
  List<Object?> get props => super.props + [sort, comments, canReply];

  DocumentViewCommentsSection copyWith({
    NodeId? id,
    DocumentCommentsSort? sort,
    List<CommentWithReplies>? comments,
    bool? canReply,
  }) {
    return DocumentViewCommentsSection(
      id: id ?? this.id,
      sort: sort ?? this.sort,
      comments: comments ?? this.comments,
      canReply: canReply ?? this.canReply,
    );
  }

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.viewCommentsSection;
  }
}
