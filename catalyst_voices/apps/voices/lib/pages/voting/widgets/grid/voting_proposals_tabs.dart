import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingProposalsTabs extends StatelessWidget {
  final TabController controller;

  const VotingProposalsTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, ProposalsCount>(
      selector: (state) => state.count,
      builder: (context, state) {
        return _VotingProposalsTabs(
          data: state,
          controller: controller,
        );
      },
    );
  }
}

class _VotingProposalsTabs extends StatelessWidget {
  final ProposalsCount data;
  final TabController controller;

  const _VotingProposalsTabs({
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isProposerUnlock = context.select<SessionCubit, bool>(
      (cubit) => cubit.state.isProposerUnlock,
    );

    return VoicesTabBar(
      dividerHeight: 0,
      controller: controller,
      onTap: (tab) {
        context.read<VotingCubit>().emitSignal(ChangeTabVotingSignal(tab.data));
      },
      tabs: [
        for (final tab in VotingPageTab.values)
          VoicesTab(
            data: tab,
            key: tab.tabKey(),
            isOffstage: !isProposerUnlock && tab == VotingPageTab.my,
            child: VoicesTabText(tab.noOf(context, count: data.ofType(tab.filter))),
          ),
      ],
    );
  }
}

extension on VotingPageTab {
  String noOf(
    BuildContext context, {
    required int count,
  }) {
    return switch (this) {
      VotingPageTab.total => context.l10n.noOfAll(count),
      VotingPageTab.favorites => context.l10n.noOfFavorites(count),
      VotingPageTab.my => context.l10n.noOfMyProposals(count),
      VotingPageTab.votedOn => context.l10n.noOfVotedOn(count),
    };
  }

  Key tabKey() {
    return switch (this) {
      VotingPageTab.total => const Key('AllProposalsTab'),
      VotingPageTab.favorites => const Key('FavoriteProposalsTab'),
      VotingPageTab.my => const Key('MyProposalsTab'),
      VotingPageTab.votedOn => const Key('VotedOnProposalsTab'),
    };
  }
}
