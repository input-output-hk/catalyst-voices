import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WorkspaceAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAppUnlock;

  const WorkspaceAppbar({
    super.key,
    required this.isAppUnlock,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    return CampaignPhaseAware.orElse(
      phase: CampaignPhaseType.proposalSubmission,
      showOnlyDataState: true,
      active: (_, _, _) => _AppBar(isAppUnlock: isAppUnlock, isActivePhase: true),
      orElse: (_, _, _) => _AppBar(isAppUnlock: isAppUnlock, isActivePhase: false),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool isActivePhase;
  final bool isAppUnlock;

  const _AppBar({
    required this.isAppUnlock,
    required this.isActivePhase,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAppBar(
      automaticallyImplyLeading: false,
      leading: (isAppUnlock && isActivePhase) ? const DrawerToggleButton() : null,
      actions: const [
        SessionCtaAction(),
        AccountSettingsAction(),
      ],
    );
  }
}
