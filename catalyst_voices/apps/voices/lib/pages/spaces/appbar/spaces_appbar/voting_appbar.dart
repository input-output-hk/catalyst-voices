import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/vote_delegation_button.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/vote_list_button.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/voting_leading_button.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VotingAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAppUnlock;

  const VotingAppbar({
    super.key,
    required this.isAppUnlock,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    return CampaignPhaseAware.orElse(
      phase: CampaignPhaseType.communityVoting,
      showOnlyDataState: true,
      orElse: (_, __, ___) {
        return _CategoryVotingAppbar(isAppUnlock: isAppUnlock);
      },
    );
  }
}

class _CategoryVotingAppbar extends StatelessWidget {
  final bool isAppUnlock;

  const _CategoryVotingAppbar({
    required this.isAppUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, bool>(
      selector: (state) => state.hasSelectedCategory,
      builder: (context, hasCategory) {
        return _VotingAppbar(
          showLeading: isAppUnlock && hasCategory,
        );
      },
    );
  }
}

class _VotingAppbar extends StatelessWidget {
  final bool showLeading;

  const _VotingAppbar({
    this.showLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAppBar(
      leading: showLeading ? const VotingLeadingButton() : null,
      automaticallyImplyLeading: false,
      actions: const [
        VoteListButton(),
        VoteDelegationButton(),
        SessionCtaAction(),
        AccountSettingsAction(),
      ],
    );
  }
}
