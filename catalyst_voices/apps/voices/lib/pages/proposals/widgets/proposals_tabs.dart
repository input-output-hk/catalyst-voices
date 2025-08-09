import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsTabs extends StatelessWidget {
  final TabController controller;

  const ProposalsTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, ProposalsCount>(
      selector: (state) => state.count,
      builder: (context, state) {
        return _ProposalsTabs(
          data: state,
          controller: controller,
        );
      },
    );
  }
}

class _ProposalsTabs extends StatelessWidget {
  final ProposalsCount data;
  final TabController controller;

  const _ProposalsTabs({
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isProposerUnlock =
        context.select<SessionCubit, bool>((cubit) => cubit.state.isProposerUnlock);

    return VoicesTabBar(
      dividerHeight: 0,
      controller: controller,
      onTap: (tab) {
        context.read<ProposalsCubit>().emitSignal(ChangeTabProposalsSignal(tab.data));
      },
      tabs: [
        for (final tab in ProposalsPageTab.values)
          VoicesTab(
            data: tab,
            key: tab.tabKey(),
            isOffstage: !isProposerUnlock && tab == ProposalsPageTab.my,
            child: VoicesTabText(tab.noOf(context, count: data.ofType(tab.filter))),
          ),
      ],
    );
  }
}

extension on ProposalsPageTab {
  String noOf(
    BuildContext context, {
    required int count,
  }) {
    return switch (this) {
      ProposalsPageTab.total => context.l10n.noOfAll(count),
      ProposalsPageTab.drafts => context.l10n.noOfDraft(count),
      ProposalsPageTab.finals => context.l10n.noOfFinal(count),
      ProposalsPageTab.favorites => context.l10n.noOfFavorites(count),
      ProposalsPageTab.my => context.l10n.noOfMyProposals(count),
    };
  }

  Key tabKey() {
    return switch (this) {
      ProposalsPageTab.total => const Key('AllProposalsTab'),
      ProposalsPageTab.drafts => const Key('DraftProposalsTab'),
      ProposalsPageTab.finals => const Key('FinalProposalsTab'),
      ProposalsPageTab.favorites => const Key('FavoriteProposalsTab'),
      ProposalsPageTab.my => const Key('MyProposalsTab'),
    };
  }
}
