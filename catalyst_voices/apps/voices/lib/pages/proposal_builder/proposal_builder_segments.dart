import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal_builder/tiles/proposal_builder_comment_tile.dart';
import 'package:catalyst_voices/widgets/comment/proposal_add_comment_tile.dart';
import 'package:catalyst_voices/widgets/comment/proposal_comments_header_tile.dart';
import 'package:catalyst_voices/widgets/list/category_requirements_list.dart';
import 'package:catalyst_voices/widgets/modals/proposals/category_brief_dialog.dart';
import 'package:catalyst_voices/widgets/tiles/specialized/proposal_tile_decoration.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

part 'proposal_builder_action_widgets.dart';
part 'proposal_builder_document_widgets.dart';

final DocumentPropertyActionOverrides _widgetActionOverrides = {
  ProposalDocument.categoryDetailsNodeId: const _CategoryDetailsAction(),
};

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

class _DocumentSection extends StatelessWidget {
  final DocumentProperty property;
  final bool isSelected;

  const _DocumentSection({
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
      selector: (state) => state.validationErrors?.showErrors ?? false,
      builder: (context, showValidationErrors) {
        return GestureDetector(
          onTap: () => _handleOnTap(context),
          child: DocumentBuilderSectionTile(
            key: ValueKey('DocumentProperty[${property.nodeId.value}]Tile'),
            section: property,
            isSelected: isSelected,
            isEditable: _isEditable,
            autovalidateMode:
                showValidationErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
            onChanged: (value) {
              final event = SectionChangedEvent(changes: value);
              context.read<ProposalBuilderBloc>().add(event);
            },
            actionOverrides: _widgetActionOverrides,
            overrides: _widgetOverrides,
          ),
        );
      },
    );
  }

  void _handleOnTap(BuildContext context) {
    SegmentsControllerScope.of(context).selectSectionStep(property.nodeId, shouldScroll: false);
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
          // TODO(damian-molinski): Remove this workaround in #2697.
          // ListView should be able to dispose its children when out of view port.
          // Read more in issue description.
          minCacheExtent: double.infinity,
          itemBuilder: (context, index) {
            final item = items[index];
            final previousItem = index == 0 ? null : items.elementAtOrNull(index - 1);
            final nextItem = items.elementAtOrNull(index + 1);

            return KeyedSubtree(
              key: ValueKey(item.id),
              child: _buildItem(
                context: context,
                item: item,
                previousItem: previousItem,
                nextItem: nextItem,
                selectedNodeId: selectedNodeId,
              ),
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

            if (item is ProposalViewCommentsSection && nextItem is ProposalAddCommentSection) {
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
            context.read<ProposalBuilderBloc>().add(UpdateCommentsSortEvent(sort: value));
          },
        ),
      ProposalCommentListItem(:final comment, :final canReply) => ProposalBuilderCommentTile(
          key: ValueKey(comment.comment.metadata.selfRef),
          comment: comment,
          canReply: canReply,
        ),
      ProposalAddCommentSection(
        :final schema,
        :final showUsernameRequired,
      ) =>
        ProposalAddCommentTile(
          schema: schema,
          showUsernameRequired: showUsernameRequired,
          onSubmit: ({required document, reply}) async {
            final event = SubmitCommentEvent(
              document: document,
              reply: reply,
            );
            context.read<ProposalBuilderBloc>().add(event);
          },
          onUsernamePicked: (value) {
            final event = UpdateUsernameEvent(value);

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
      DocumentSection() => _DocumentSection(
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
