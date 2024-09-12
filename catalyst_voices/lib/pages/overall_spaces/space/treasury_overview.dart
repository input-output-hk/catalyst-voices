import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:flutter/material.dart';

class TreasuryOverview extends StatelessWidget {
  const TreasuryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewContainer(child: Text('treasury'));
  }
}
