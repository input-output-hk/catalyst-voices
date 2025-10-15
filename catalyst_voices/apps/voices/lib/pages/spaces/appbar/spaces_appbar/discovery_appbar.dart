import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
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
      active: (_, _, _) =>
          _AppBar(isAppUnlock: isAppUnlock, isProposer: isProposer, isActivePhase: true),
      orElse: (_, _, _) =>
          _AppBar(isAppUnlock: isAppUnlock, isProposer: isProposer, isActivePhase: false),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool isAppUnlock;
  final bool isProposer;
  final bool isActivePhase;

  const _AppBar({
    required this.isAppUnlock,
    required this.isProposer,
    required this.isActivePhase,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAppBar(
      automaticallyImplyLeading: false,
      leading: (isAppUnlock && isActivePhase) ? const DrawerToggleButton() : null,
      actions: [
        if (isProposer && isActivePhase) const CreateProposalButton(),
        const SessionCtaAction(),
        const AccountSettingsAction(),
      ],
    );
  }
}
