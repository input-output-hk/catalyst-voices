import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DiscoveryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAppUnlock;
  final bool isProposer;

  const DiscoveryAppbar({
    super.key,
    required this.isAppUnlock,
    required this.isProposer,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    return CampaignPhaseAware.orElse(
      phase: CampaignPhaseType.proposalSubmission,
      showOnlyDataState: true,
      orElse: (_, __, ___) => const SizedBox.shrink(),
      active: (_, __, ___) => VoicesAppBar(
        leading: isAppUnlock ? const DrawerToggleButton() : null,
        actions: [
          if (isProposer) const CreateProposalButton(),
          const SessionActionHeader(),
          const SessionStateHeader(),
        ],
      ),
    );
  }
}
