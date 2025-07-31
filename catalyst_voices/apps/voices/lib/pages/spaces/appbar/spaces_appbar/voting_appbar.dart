import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/vote_list_button.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/voting_leading_button.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
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
      orElse: (_, __, ___) => VoicesAppBar(
        leading: isAppUnlock ? const VotingLeadingButton() : null,
        actions: const [
          SessionActionHeader(),
          VoteListButton(),
        ],
      ),
    );
  }
}
