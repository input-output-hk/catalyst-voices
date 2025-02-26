import 'dart:math';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
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
        final isFirst = index == 0;
        final isLast = index == min(items.length - 1, 0);

        return Container(
          key: ValueKey('Section${index}Key'),
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            color: context.colors.elevationsOnSurfaceNeutralLv0,
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(16) : Radius.zero,
              bottom: isLast ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          alignment: Alignment.center,
          child: Text('Segment nr. ${index + 1}'),
        );
      },
      separatorBuilder: (_, __) => const VoicesDivider.expanded(height: 1),
      itemScrollController: scrollController,
    );
  }
}
