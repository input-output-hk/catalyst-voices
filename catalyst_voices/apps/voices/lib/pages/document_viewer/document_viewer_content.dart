import 'dart:async';
import 'dart:math';

import 'package:catalyst_voices/pages/document_viewer/tiles/document_comment_tile.dart';
import 'package:catalyst_voices/pages/document_viewer/tiles/document_section_tile.dart';
import 'package:catalyst_voices/pages/document_viewer/tiles/document_segment_title.dart';
import 'package:catalyst_voices/pages/proposal_viewer/tiles/proposal_metadata_tile.dart';
import 'package:catalyst_voices/pages/proposal_viewer/tiles/proposal_overview_tile.dart';
import 'package:catalyst_voices/pages/proposal_viewer/tiles/proposal_voting_overview.dart';
import 'package:catalyst_voices/widgets/comment/document_add_comment_tile.dart';
import 'package:catalyst_voices/widgets/comment/document_comments_header_tile.dart';
import 'package:catalyst_voices/widgets/tiles/specialized/proposal_tile_decoration.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DocumentViewerContent extends StatelessWidget {
  final ItemScrollController scrollController;

  const DocumentViewerContent({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentViewerCubit, DocumentViewerState, bool>(
      selector: (state) => state.showData,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: _DocumentViewerContent(scrollController: scrollController),
        );
      },
    );
  }
}

class _DocumentViewerContent extends StatelessWidget {
  final ItemScrollController scrollController;

  const _DocumentViewerContent({
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
          key: const ValueKey('DocumentViewerContentListView'),
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
      key: const ValueKey('DocumentViewerSegmentsListView'),
      items: items,
      itemScrollController: scrollController,
      padding: const EdgeInsets.only(top: 56, bottom: 64),
      itemBuilder: (context, index) {
        final item = items[index];
        final nextItem = items.elementAtOrNull(index + 1);

        final isFirst = index == 0;
        final isLast = index == max(items.length - 1, 0);

        final isSegment = item is Segment;
        final isNextComment = nextItem is DocumentCommentListItem;
        final isNextSectionOrComment = nextItem is Section || isNextComment;
        final isCommentsSegment = item is DocumentCommentsSegment;
        final isNotEmptyCommentsSegment = isCommentsSegment && item.hasComments;
        final isVotingStatusSection = item is ProposalVotingStatusSection;

        return ProposalTileDecoration(
          key: ValueKey('Proposal.${item.id.value}.Tile'),
          corners: (
            isFirst: isFirst || isCommentsSegment,
            isLast: isLast || nextItem is DocumentCommentsSegment,
          ),
          verticalPadding: (
            isFirst: isSegment,
            isLast:
                (!isNextSectionOrComment && !isVotingStatusSection) || isNotEmptyCommentsSegment,
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

        if (nextItem is DocumentAddCommentSection) {
          return const ProposalDivider(height: 48);
        }

        if (nextItem is DocumentCommentsSegment) {
          return const SizedBox(height: 32);
        }

        if (nextItem is Segment && item is! ProposalVotingStatusSection) {
          return const VoicesDivider.expanded(height: 1);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildItem(BuildContext context, SegmentsListViewItem item) {
    final baseCubit = context.read<DocumentViewerCubit>();
    final cubitWithComments = baseCubit is DocumentViewerCommentsMixin ? baseCubit : null;
    return switch (item) {
      ProposalVotingOverviewSegment() => const SizedBox.shrink(),
      ProposalVotingOverviewSection() => switch (item) {
        ProposalVotingStatusSection(:final data) => ProposalVotingOverview(data),
      },
      ProposalOverviewSegment(
        :final categoryName,
        :final proposalTitle,
        :final isVotingStage,
      ) =>
        ProposalOverviewTile(
          categoryName: categoryName,
          proposalTitle: proposalTitle,
          isVotingStage: isVotingStage,
        ),
      ProposalOverviewSection() => switch (item) {
        ProposalMetadataSection(:final data) => ProposalMetadataTile(
          author: data.author,
          collaborators: data.collaborators,
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
      DocumentSegment() => DocumentSegmentTitle(
        title: item.resolveTitle(context),
      ),
      DocumentSection(:final property) => DocumentSectionTile(
        property: property,
      ),
      DocumentCommentsSegment(:final sort) => DocumentCommentsHeaderTile(
        sort: sort,
        showSort: item.hasComments,
        onChanged: (value) {
          cubitWithComments?.updateCommentsSort(sort: value);
        },
      ),
      DocumentCommentsSection() => switch (item) {
        DocumentViewCommentsSection() => const SizedBox.shrink(),
        DocumentAddCommentSection(
          :final schema,
          :final showUsernameRequired,
        ) =>
          DocumentAddCommentTile(
            schema: schema,
            showUsernameRequired: showUsernameRequired,
            onSubmit: ({required document, reply}) async {
              return cubitWithComments?.submitComment(document: document, reply: reply);
            },
            onUsernamePicked: (value) {
              unawaited(cubitWithComments?.updateUsername(value));
            },
          ),
      },
      DocumentCommentListItem(
        :final comment,
        :final canReply,
      ) =>
        DocumentCommentTile(
          key: ValueKey(comment.comment.metadata.id),
          comment: comment,
          canReply: canReply,
        ),
      _ => throw ArgumentError('Not supported type ${item.runtimeType}'),
    };
  }
}
