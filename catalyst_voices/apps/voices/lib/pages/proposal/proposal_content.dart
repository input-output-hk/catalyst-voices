import 'dart:math';

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
      itemBuilder: (context, index) {
        final item = items[index];

        return ProposalTileDecoration(
          key: ValueKey('Proposal[${item.id.value}]Tile'),
          position: (
            isFirst: index == 0,
            isLast: index == max(items.length - 1, 0),
          ),
          positionInSegment: (
            isFirst: item is Segment,
            isLast: items.elementAtOrNull(index + 1) is! Section,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 100),
            alignment: Alignment.center,
            child: Text('$index'),
          ),
        );
      },
      separatorBuilder: (context, index) {
        final nextItem = items.elementAtOrNull(index + 1);

        if (nextItem is Segment) {
          return const VoicesDivider.expanded(height: 1);
        }

        return const SizedBox.shrink();
      },
      itemScrollController: scrollController,
    );
  }
}
