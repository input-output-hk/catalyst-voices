import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VotingOverview extends StatelessWidget {
  const VotingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewContainer(
      child: Column(
        children: [
          const SpaceOverviewHeader(Space.voting),
          SectionHeader(
            title: Text(
              context.l10n.comingSoon,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
