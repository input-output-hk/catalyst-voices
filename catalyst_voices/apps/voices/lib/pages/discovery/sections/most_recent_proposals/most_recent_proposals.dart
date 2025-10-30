import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals/widgets/most_recent_offstage.dart';
import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals/widgets/recent_proposals.dart';
import 'package:flutter/material.dart';

class MostRecentProposals extends StatelessWidget {
  const MostRecentProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return const MostRecentOffstage(child: RecentProposals());
  }
}
