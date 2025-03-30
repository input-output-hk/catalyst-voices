import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum CommentsSort {
  newest,
  oldest;

  SvgGenImage get icon {
    return switch (this) {
      CommentsSort.newest => VoicesAssets.icons.sortDescending,
      CommentsSort.oldest => VoicesAssets.icons.sortAscending,
    };
  }

  List<CommentWithReplies> applyTo(List<CommentWithReplies> data) {
    return data
        .map((e) {
          return e.copyWith(
            // Replies always have oldest to newest order
            replies: CommentsSort.oldest.applyTo(e.replies),
          );
        })
        .sortedByCompare(
          (element) => element.comment.metadata.selfRef,
          (a, b) => switch (this) {
            CommentsSort.newest => a.compareTo(b) * -1,
            CommentsSort.oldest => a.compareTo(b),
          },
        )
        .toList();
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      CommentsSort.newest => context.l10n.proposalCommentsSortNewest,
      CommentsSort.oldest => context.l10n.proposalCommentsSortOldest,
    };
  }
}

extension SegmentsExt on Iterable<Segment> {
  Iterable<Segment> sortWith({required CommentsSort sort}) {
    return List.of(this).map(
      (segment) {
        return segment is CommentsSegment
            ? segment.copySorted(sort: sort)
            : segment;
      },
    );
  }
}
