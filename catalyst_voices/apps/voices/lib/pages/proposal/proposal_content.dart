import 'dart:math';

import 'package:catalyst_voices/pages/proposal/tiles/proposal_add_comment_tile.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_comment_tile.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_comments_header_tile.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_document_section_tile.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_document_segment_title.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_metadata_tile.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_overview_tile.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_tile_decoration.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalContent extends StatelessWidget {
  final ItemScrollController scrollController;

  const ProposalContent({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: _SegmentsListenable(
        scrollController: scrollController,
      ),
    );
  }
}

class _SegmentsListenable extends StatelessWidget {
  final ItemScrollController scrollController;

  const _SegmentsListenable({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, child) {
        return _SegmentsListView(
          key: const ValueKey('ProposalContentListView'),
          scrollController: scrollController,
          items: value.listItems,
        );
      },
    );
  }
}

class _SegmentsListView extends StatelessWidget {
  final ItemScrollController scrollController;
  final List<SegmentsListViewItem> items;

  const _SegmentsListView({
    super.key,
    required this.scrollController,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BasicSegmentsListView(
      key: const ValueKey('ProposalSegmentsListView'),
      items: items,
      itemScrollController: scrollController,
      padding: const EdgeInsets.only(top: 56, bottom: 64),
      itemBuilder: (context, index) {
        final item = items[index];
        final nextItem = items.elementAtOrNull(index + 1);

        final isFirst = index == 0;
        final isLast = index == max(items.length - 1, 0);

        return ProposalTileDecoration(
          key: ValueKey('Proposal.${item.id.value}.Tile'),
          corners: (
            isFirst: isFirst || item is ProposalCommentsSegment,
            isLast: isLast || nextItem is ProposalCommentsSegment,
          ),
          verticalPadding: (
            isFirst: item is Segment,
            isLast: (nextItem is! Section && nextItem is! CommentListItem) ||
                (item is ProposalCommentsSegment),
          ),
          child: _buildItem(context, item),
        );
      },
      separatorBuilder: (context, index) {
        final item = items[index];
        final nextItem = items.elementAtOrNull(index + 1);

        if (item is DocumentSegment && nextItem is DocumentSection) {
          return const ProposalSeparatorBox(height: 24);
        }

        if (item is DocumentSection && nextItem is DocumentSection) {
          return const ProposalSeparatorBox(height: 24);
        }

        if (nextItem is AddCommentSection) {
          return const ProposalDivider(height: 48);
        }

        if (nextItem is ProposalCommentsSegment) {
          return const SizedBox(height: 32);
        }

        if (nextItem is Segment) {
          return const VoicesDivider.expanded(height: 1);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildItem(BuildContext context, SegmentsListViewItem item) {
    return switch (item) {
      ProposalOverviewSegment(
        :final categoryName,
        :final proposalTitle,
      ) =>
        ProposalOverviewTile(
          categoryName: categoryName,
          proposalTitle: proposalTitle,
        ),
      ProposalOverviewSection() => switch (item) {
          ProposalMetadataSection(:final data) => ProposalMetadataTile(
              author: data.author,
              description: data.description,
              status: data.status,
              createdAt: data.createdAt,
              warningCreatedAt: data.warningCreatedAt,
              tag: data.tag,
              commentsCount: data.commentsCount,
              fundsRequested: data.fundsRequested,
              projectDuration: data.projectDuration,
              milestoneCount: data.milestoneCount,
            ),
        },
      DocumentSegment() => ProposalDocumentSegmentTitle(
          title: item.resolveTitle(context),
        ),
      DocumentSection(:final property) => ProposalDocumentSectionTile(
          property: property,
        ),
      ProposalCommentsSegment(:final sort) => ProposalCommentsHeaderTile(
          sort: sort,
        ),
      ProposalCommentsSection() => switch (item) {
          ViewCommentsSection() => throw ArgumentError(
              'View comments not supported',
            ),
          AddCommentSection(:final schema) => ProposalAddCommentTile(
              schema: schema,
            ),
        },
      CommentListItem(:final comment) => ProposalCommentTile(
          key: ValueKey(comment.comment.metadata.selfRef),
          comment: comment,
        ),
      _ => throw ArgumentError('Not supported type ${item.runtimeType}'),
    };
  }
}
