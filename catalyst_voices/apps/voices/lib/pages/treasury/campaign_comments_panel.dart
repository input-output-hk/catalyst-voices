import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CampaignCommentsPanel extends StatelessWidget {
  const CampaignCommentsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: 'Campaign comments',
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
