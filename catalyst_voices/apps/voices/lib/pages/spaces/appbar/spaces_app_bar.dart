import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/delegation_button.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/vote_list_button.dart';
import 'package:catalyst_voices/pages/spaces/appbar/voting/voting_leading_button.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Space space;
  final bool isActive;
  final bool isProposer;

  const SpacesAppBar({
    super.key,
    required this.space,
    required this.isActive,
    required this.isProposer,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    return VoicesAppBar(
      leading: _getLeading(context),
      automaticallyImplyLeading: false,
      actions: _getActions(),
    );
  }

  List<Widget> _getActions() {
    if (space == Space.treasury) {
      return const [];
    } else if (space == Space.voting) {
      return [
        const VoteListButton(),
        const DelegationButton(),
        const SessionStateHeader(),
      ];
    } else {
      return [
        if (space == Space.discovery && isProposer) const CreateProposalButton(),
        const SessionActionHeader(),
        const SessionStateHeader(),
      ];
    }
  }

  Widget? _getLeading(BuildContext context) {
    if (!isActive) {
      return null;
    } else if (space == Space.voting) {
      return const VotingLeadingButton();
    } else {
      return const DrawerToggleButton();
    }
  }
}
