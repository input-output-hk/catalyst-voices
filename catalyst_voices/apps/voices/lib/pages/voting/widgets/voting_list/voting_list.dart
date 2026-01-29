import 'package:catalyst_voices/pages/spaces/spaces.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_ballot.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_bottom_sheet.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_campaign_phase_progress.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_footer.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_header.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_user_summary.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VotingList extends StatelessWidget {
  const VotingList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        VotingListHeader(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: 8),
                VotingListCampaignPhaseProgress(),
                SizedBox(height: 32),
                VotingListUserSummary(),
                SizedBox(height: 16),
                Expanded(child: VotingListBallot()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// TODO(LynxLynxx): Refactor to use New Drawer API as Page
class VotingListDrawer extends StatelessWidget {
  const VotingListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoicesDrawer(
      width: 500,
      bottomSheet: VotingListBottomSheet(),
      footer: VotingListFooter(),
      child: VotingList(),
    );
  }

  static void close(BuildContext context) {
    Scaffold.of(context).closeEndDrawer();
  }

  /// This method is meant to be used inside [SpacesShellPage].
  static void open(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}
