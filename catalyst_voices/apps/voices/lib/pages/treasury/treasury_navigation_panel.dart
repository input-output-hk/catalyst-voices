import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices/widgets/navigation/sections_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class TreasuryNavigationPanel extends StatelessWidget {
  const TreasuryNavigationPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: context.l10n.treasuryCampaignBuilder,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: context.l10n.treasuryCampaignBuilderSegments,
          body: SectionsMenuListener(
            controller: SectionsControllerScope.of(context),
          ),
        ),
      ],
    );
  }
}
