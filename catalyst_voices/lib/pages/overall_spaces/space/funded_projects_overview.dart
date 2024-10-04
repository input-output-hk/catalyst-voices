import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class FundedProjectsOverview extends StatelessWidget {
  const FundedProjectsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        children: [
          SpaceOverviewHeader(Space.fundedProjects),
        ],
      ),
    );
  }
}
