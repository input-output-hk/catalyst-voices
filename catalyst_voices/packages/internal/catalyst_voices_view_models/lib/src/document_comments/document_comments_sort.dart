import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Enum representing proposal comments sort options
enum DocumentCommentsSort {
  newest,
  oldest;

  SvgGenImage get icon {
    return switch (this) {
      DocumentCommentsSort.newest => VoicesAssets.icons.sortDescending,
      DocumentCommentsSort.oldest => VoicesAssets.icons.sortAscending,
    };
  }

  List<CommentWithReplies> applyTo(List<CommentWithReplies> data) {
    return data
        .map((e) {
          return e.copyWith(
            // Replies always have oldest to newest order
            replies: DocumentCommentsSort.oldest.applyTo(e.replies),
          );
        })
        .sortedByCompare(
          (element) => element.comment.metadata.id,
          (a, b) => switch (this) {
            DocumentCommentsSort.newest => a.compareTo(b) * -1,
            DocumentCommentsSort.oldest => a.compareTo(b),
          },
        )
        .toList();
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      DocumentCommentsSort.newest => context.l10n.commentsSortNewest,
      DocumentCommentsSort.oldest => context.l10n.commentsSortOldest,
    };
  }
}

extension SegmentsExt on Iterable<Segment> {
  Iterable<Segment> sortWith({required DocumentCommentsSort sort}) {
    return List.of(this).map(
      (segment) {
        return segment is DocumentCommentsSegment ? segment.copySorted(sort: sort) : segment;
      },
    );
  }
}
