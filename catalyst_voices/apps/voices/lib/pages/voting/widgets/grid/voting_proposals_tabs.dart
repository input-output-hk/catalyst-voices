import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingProposalsTabs extends StatelessWidget {
  final VoicesTabController<VotingPageTab> controller;

  const VotingProposalsTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTabBar(
      dividerHeight: 0,
      controller: controller,
      onTap: (tab) {
        context.read<VotingCubit>().emitSignal(ChangeTabVotingSignal(tab.data));
      },
      tabs: [
        for (final tab in controller.tabs)
          VoicesTab(
            data: tab,
            key: tab.tabKey(),
            child: _TabText(key: ValueKey('${tab.name}Text'), tab: tab),
          ),
      ],
    );
  }
}

class _TabText extends StatelessWidget {
  final VotingPageTab tab;

  const _TabText({
    required super.key,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, int>(
      selector: (state) => state.count[tab] ?? 0,
      builder: (context, state) => VoicesTabText(tab.noOf(context, count: state)),
    );
  }
}

extension on VotingPageTab {
  String noOf(
    BuildContext context, {
    required int count,
  }) {
    return switch (this) {
      VotingPageTab.results => context.l10n.results,
      VotingPageTab.total => context.l10n.noOfAllFinalProposals(count),
      VotingPageTab.favorites => context.l10n.noOfFavoriteFinals(count),
      VotingPageTab.myFinalProposals => context.l10n.noOfMyFinalProposals(count),
      VotingPageTab.myVotes => context.l10n.noOfMyVotes(count),
    };
  }

  Key tabKey() {
    return switch (this) {
      VotingPageTab.results => const Key('ResultsTab'),
      VotingPageTab.total => const Key('AllProposalsTab'),
      VotingPageTab.favorites => const Key('FavoriteProposalsTab'),
      VotingPageTab.myFinalProposals => const Key('MyProposalsTab'),
      VotingPageTab.myVotes => const Key('VotedOnProposalsTab'),
    };
  }
}
