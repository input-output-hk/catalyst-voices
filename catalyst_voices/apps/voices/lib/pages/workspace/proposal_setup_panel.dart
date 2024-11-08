import 'package:catalyst_voices/common/ext/guidance_ext.dart';
import 'package:catalyst_voices/widgets/cards/comment_card.dart';
import 'package:catalyst_voices/widgets/cards/guidance_card.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<Guidance> _mockGuidance = [
  const Guidance(
    title: 'Use a Compelling Hook or Unique Angle',
    description:
        'Adding an element of intrigue or a unique approach can make your title stand out. For example, “Revolutionizing Urban Mobility with Eco-Friendly Innovation” not only describes the proposal but also piques curiosity.',
    type: GuidanceType.tips,
    weight: 1,
  ),
  const Guidance(
    title: 'Be Specific and Solution-Oriented',
    description:
        'Use keywords that pinpoint the problem you’re solving or the opportunity you’re capitalizing on. A title like “Streamlining Supply Chains for Cost-Effective and Rapid Delivery” instantly tells the reader what the proposal aims to achieve.',
    type: GuidanceType.mandatory,
    weight: 2,
  ),
  const Guidance(
    title: 'Highlight the Benefit or Outcome',
    description:
        'Make sure the reader can immediately see the value or the end result of your proposal. A title like “Boosting Engagement and Growth through Targeted Digital Strategies” puts the focus on the positive outcomes.',
    type: GuidanceType.mandatory,
    weight: 1,
  ),
  const Guidance(
    title: 'Education',
    description: 'Use keywords that pinpoint the problem yo',
    type: GuidanceType.education,
    weight: 1,
  ),
];

class ProposalSetupPanel extends StatelessWidget {
  const ProposalSetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: context.l10n.workspaceProposalSetup,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Guidance',
          body: _GuidanceView(
            guidances: _mockGuidance,
          ),
        ),
        SpaceSidePanelTab(
          name: 'Comments',
          body: CommentCard(
            comment: Comment(
              text: 'Lacks clarity on key objectives and measurable outcomes.',
              date: DateTime.now(),
              userName: 'Community Member',
            ),
          ),
        ),
        //(ryszard-schossler) No actions for now
        // SpaceSidePanelTab(
        //   name: 'Actions',
        //   body: const Offstage(),
        // ),
      ],
    );
  }
}

class _GuidanceView extends StatelessWidget {
  final List<Guidance> guidances;
  const _GuidanceView({
    required this.guidances,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuidanceCubit(guidances),
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VoicesDropdown<GuidanceType?>(
              items: GuidanceType.values
                  .map(
                    (e) => VoicesDropdownMenuEntry<GuidanceType>(
                      label: e.localizedType(context.l10n),
                      value: e,
                      context: context,
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  context.read<GuidanceCubit>().filterGuidances(value),
            ),
            BlocBuilder<GuidanceCubit, GuidanceState>(
              builder: (context, state) {
                return switch (state) {
                  NoGuidance() => const SizedBox.shrink(),
                  SelectedGuidances() => Column(
                      children: state.guidances
                          .sortedByWeight()
                          .toList()
                          .map((e) => GuidanceCard(guidance: e))
                          .toList(),
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
