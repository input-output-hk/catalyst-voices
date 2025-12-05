import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Section for adding a comment to a proposal
final class ProposalAddCommentSection extends ProposalCommentsSection {
  final DocumentSchema schema;
  final bool showUsernameRequired;

  const ProposalAddCommentSection({
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
final class ProposalCommentListItem extends Equatable implements SegmentsListViewItem {
  @override
  final NodeId id;
  final CommentWithReplies comment;
  final bool canReply;

  const ProposalCommentListItem({
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
sealed class ProposalCommentsSection extends BaseSection {
  const ProposalCommentsSection({
    required super.id,
  });
}

/// Segment for comments in a proposal
final class ProposalCommentsSegment extends BaseSegment<ProposalCommentsSection> {
  final ProposalCommentsSort sort;

  const ProposalCommentsSegment({
    required super.id,
    required this.sort,
    required super.sections,
  });

  bool get hasComments => sections.whereType<ProposalViewCommentsSection>().any(
    (element) => element.comments.isNotEmpty,
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
        ProposalAddCommentSection() => section,
        ProposalViewCommentsSection() => section.copyWith(
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
    return context.l10n.commentsSegment;
  }
}

/// Section for viewing comments in a proposal
final class ProposalViewCommentsSection extends ProposalCommentsSection
    implements SegmentGroupedListViewItems {
  final ProposalCommentsSort sort;
  final List<CommentWithReplies> comments;
  final bool canReply;

  const ProposalViewCommentsSection({
    required super.id,
    required this.sort,
    required this.comments,
    required this.canReply,
  });

  @override
  Iterable<SegmentsListViewItem> get children {
    return comments.mapIndexed((index, comment) {
      return ProposalCommentListItem(
        id: id.child(comment.comment.metadata.id.id),
        comment: comment,
        canReply: canReply,
      );
    });
  }

  @override
  List<Object?> get props => super.props + [sort, comments, canReply];

  ProposalViewCommentsSection copyWith({
    NodeId? id,
    ProposalCommentsSort? sort,
    List<CommentWithReplies>? comments,
    bool? canReply,
  }) {
    return ProposalViewCommentsSection(
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
