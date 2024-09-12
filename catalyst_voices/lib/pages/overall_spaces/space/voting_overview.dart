import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:flutter/material.dart';

class VotingOverview extends StatelessWidget {
  const VotingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewContainer(child: Text('voting'));
  }
}
