import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderBody extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const ProposalBuilderBody({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentsListViewBuilder(
      builder: (context, value, child) {
        return SegmentsListView<ProposalBuilderSegment, ProposalBuilderSection>(
          itemScrollController: itemScrollController,
          items: value,
          sectionBuilder: (context, data) {
            return Text(
              '${data.id}',
            );
          },
        );
      },
    );
  }
}
