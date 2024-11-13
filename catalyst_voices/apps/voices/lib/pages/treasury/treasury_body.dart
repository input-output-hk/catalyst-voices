import 'package:catalyst_voices/pages/treasury/treasury_dummy_topic_step.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TreasuryBody extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const TreasuryBody({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SectionsControllerScope.of(context),
      builder: (context, value, child) {
        return SectionsListView<TreasurySection, TreasurySectionStep>(
          itemScrollController: itemScrollController,
          items: value.listItems,
          stepBuilder: (context, step) {
            switch (step) {
              case DummyTopicStep():
                return TreasuryDummyTopicStep(step: step);
            }
          },
        );
      },
    );
  }
}
