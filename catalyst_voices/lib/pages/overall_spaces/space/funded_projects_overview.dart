import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:flutter/material.dart';

class FundedProjectsOverview extends StatelessWidget {
  const FundedProjectsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewContainer(child: Text('fundedProjects'));
  }
}
