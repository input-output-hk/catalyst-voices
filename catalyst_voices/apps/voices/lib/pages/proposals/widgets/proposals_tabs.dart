import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsTabs extends StatelessWidget {
  final VoicesTabController<ProposalsPageTab> controller;

  const ProposalsTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTabBar(
      dividerHeight: 0,
      controller: controller,
      onTap: (tab) {
        context.read<ProposalsCubit>().emitSignal(ChangeTabProposalsSignal(tab.data));
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
  final ProposalsPageTab tab;

  const _TabText({
    required super.key,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, int>(
      selector: (state) => state.count[tab] ?? 0,
      builder: (context, state) => VoicesTabText(tab.noOf(context, count: state)),
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
