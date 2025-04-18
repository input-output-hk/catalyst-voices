import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TreasuryDetailsPanel extends StatelessWidget {
  const TreasuryDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Comments',
          body: const Offstage(),
        ),
      ],
    );
  }
}
