import 'package:catalyst_voices/pages/treasury/treasury_dummy_topic_step.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TreasuryBody extends StatelessWidget {
  final List<SectionsListViewItem> items;

  const TreasuryBody({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SectionsListView<TreasurySection, TreasurySectionStep>(
      items: items,
      stepBuilder: (context, step) {
        switch (step) {
          case DummyTopicStep():
            return TreasuryDummyTopicStep(step: step);
        }
      },
    );
  }
}
