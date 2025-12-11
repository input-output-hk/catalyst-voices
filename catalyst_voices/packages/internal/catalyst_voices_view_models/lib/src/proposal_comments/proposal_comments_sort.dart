import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Enum representing proposal comments sort options
enum ProposalCommentsSort {
  newest,
  oldest;

  SvgGenImage get icon {
    return switch (this) {
      ProposalCommentsSort.newest => VoicesAssets.icons.sortDescending,
      ProposalCommentsSort.oldest => VoicesAssets.icons.sortAscending,
    };
  }

  List<CommentWithReplies> applyTo(List<CommentWithReplies> data) {
    return data
        .map((e) {
          return e.copyWith(
            // Replies always have oldest to newest order
            replies: ProposalCommentsSort.oldest.applyTo(e.replies),
          );
        })
        .sortedByCompare(
          (element) => element.comment.metadata.id,
          (a, b) => switch (this) {
            ProposalCommentsSort.newest => a.compareTo(b) * -1,
            ProposalCommentsSort.oldest => a.compareTo(b),
          },
        )
        .toList();
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      ProposalCommentsSort.newest => context.l10n.commentsSortNewest,
      ProposalCommentsSort.oldest => context.l10n.commentsSortOldest,
    };
  }
}

extension SegmentsExt on Iterable<Segment> {
  Iterable<Segment> sortWith({required ProposalCommentsSort sort}) {
    return List.of(this).map(
      (segment) {
        return segment is ProposalCommentsSegment ? segment.copySorted(sort: sort) : segment;
      },
    );
  }
}
