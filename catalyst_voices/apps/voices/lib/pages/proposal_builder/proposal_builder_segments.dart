import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/proposal/tiles/proposal_tile_decoration.dart';
import 'package:catalyst_voices/pages/proposal_builder/tiles/proposal_builder_comment_tile.dart';
import 'package:catalyst_voices/widgets/comment/proposal_add_comment_tile.dart';
import 'package:catalyst_voices/widgets/comment/proposal_comments_header_tile.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

part 'proposal_builder_document_widgets.dart';

final DocumentPropertyBuilderOverrides _widgetOverrides = {
  ProposalDocument.categoryDetailsNodeId: (context, property) =>
      _CategoryDetails(property: property),
};

class ProposalBuilderSegmentsSelector extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const ProposalBuilderSegmentsSelector({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.showSegments,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: _ProposalBuilderSegments(
            itemScrollController: itemScrollController,
          ),
        );
      },
    );
  }
}

class _ProposalBuilderSegments extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const _ProposalBuilderSegments({
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, child) {
        final items = value.listItems;
        final selectedNodeId = value.activeSectionId;
        return BasicSegmentsListView(
          key: const ValueKey('ProposalBuilderSegmentsListView'),
          items: items,
          itemScrollController: itemScrollController,
          padding: const EdgeInsets.only(top: 16, bottom: 64),
          itemBuilder: (context, index) {
            final item = items[index];
            final previousItem =
                index == 0 ? null : items.elementAtOrNull(index - 1);
            final nextItem = items.elementAtOrNull(index + 1);

            return _buildItem(
              context: context,
              item: item,
              previousItem: previousItem,
              nextItem: nextItem,
              selectedNodeId: selectedNodeId,
            );
          },
          separatorBuilder: (context, index) {
            final item = items[index];
            final nextItem = items.elementAtOrNull(index + 1);

            if (nextItem is ProposalCommentsSegment) {
              return const SizedBox(height: 32);
            }

            if (item is ProposalCommentsSegment && nextItem != null) {
              return const SizedBox(height: 32);
            }

            if (item is ProposalViewCommentsSection && nextItem != null) {
              return const ProposalSeparatorBox(height: 24);
            }

            if ((item is ProposalViewCommentsSection ||
                    item is ProposalCommentListItem) &&
                nextItem is ProposalAddCommentSection) {
              return const ProposalDivider(height: 48);
            }

            if (item is DocumentSegment || item is DocumentSection) {
              return const SizedBox(height: 12);
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildCommentSection({
    required BuildContext context,
    required SegmentsListViewItem item,
  }) {
    return switch (item) {
      ProposalViewCommentsSection(:final sort) => ProposalCommentsHeaderTile(
          sort: sort,
          showSort: item.comments.isNotEmpty,
          onChanged: (value) {
            context
                .read<ProposalBuilderBloc>()
                .add(UpdateCommentsSortEvent(sort: value));
          },
        ),
      ProposalCommentListItem(:final comment, :final canReply) =>
        ProposalBuilderCommentTile(
          key: ValueKey(comment.comment.metadata.selfRef),
          comment: comment,
          canReply: canReply,
        ),
      ProposalAddCommentSection(:final schema) => ProposalAddCommentTile(
          schema: schema,
          onSubmit: ({required document, reply}) async {
            final event = SubmitCommentEvent(
              document: document,
              reply: reply,
            );
            context.read<ProposalBuilderBloc>().add(event);
          },
        ),
      _ => throw ArgumentError('Not supported type ${item.runtimeType}'),
    };
  }

  Widget _buildDecoratedCommentSection({
    required BuildContext context,
    required SegmentsListViewItem item,
    required SegmentsListViewItem? previousItem,
    required SegmentsListViewItem? nextItem,
  }) {
    final isFirst = previousItem is ProposalCommentsSegment;
    final isLast = nextItem == null;

    return ProposalTileDecoration(
      key: ValueKey('Proposal.${item.id.value}.Tile'),
      corners: (
        isFirst: isFirst,
        isLast: isLast,
      ),
      verticalPadding: (
        isFirst: isFirst,
        isLast: isLast,
      ),
      child: _buildCommentSection(context: context, item: item),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required SegmentsListViewItem item,
    required SegmentsListViewItem? previousItem,
    required SegmentsListViewItem? nextItem,
    required NodeId? selectedNodeId,
  }) {
    return switch (item) {
      DocumentSegment() => SegmentHeaderTile(
          id: item.id,
          name: item.resolveTitle(context),
        ),
      ProposalCommentsSegment() => SegmentHeaderTile(
          id: item.id,
          name: item.resolveTitle(context),
        ),
      DocumentSection() => _Section(
          property: item.property,
          isSelected: item.property.nodeId == selectedNodeId,
        ),
      _ => _buildDecoratedCommentSection(
          context: context,
          item: item,
          previousItem: previousItem,
          nextItem: nextItem,
        ),
    };
  }
}

class _Section extends StatelessWidget {
  final DocumentProperty property;
  final bool isSelected;

  const _Section({
    required this.property,
    required this.isSelected,
  });

  bool get _isEditable {
    for (final overriddenNodeId in _widgetOverrides.keys) {
      final sectionHasOverrides = overriddenNodeId.isChildOf(property.nodeId);
      if (sectionHasOverrides) {
        // disable editing for overridden widgets
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.showValidationErrors,
      builder: (context, showValidationErrors) {
        return DocumentBuilderSectionTile(
          key: key,
          section: property,
          isSelected: isSelected,
          isEditable: _isEditable,
          autovalidateMode: showValidationErrors
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          onChanged: (value) {
            final event = SectionChangedEvent(changes: value);
            context.read<ProposalBuilderBloc>().add(event);
          },
          overrides: _widgetOverrides,
        );
      },
    );
  }
}
