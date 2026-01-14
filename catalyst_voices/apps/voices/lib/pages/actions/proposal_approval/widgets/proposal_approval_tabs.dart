import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_decide_tab.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_final_tab.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_decorated_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalTabs extends StatelessWidget {
  final TabController tabController;

  const ProposalApprovalTabs({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return ActionsDecoratedPanel(
      padding: EdgeInsets.zero,
      child: BlocBuilder<ProposalApprovalCubit, ProposalApprovalState>(
        builder: (context, state) {
          final decideItems = state.decideItems;
          final finalItems = state.finalItems;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _TabBar(
                  tabController: tabController,
                  decideCount: decideItems.length,
                  finalCount: finalItems.length,
                ),
              ),
              Flexible(
                child: _TabBarView(
                  tabController: tabController,
                  decideItems: decideItems,
                  finalItems: finalItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final TabController tabController;
  final int decideCount;
  final int finalCount;

  const _TabBar({
    required this.tabController,
    required this.decideCount,
    required this.finalCount,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTabBar(
      controller: tabController,
      tabs: [
        VoicesTab(
          data: ProposalApprovalTabType.decide,
          child: Text(context.l10n.noOfDecide(decideCount)),
        ),
        VoicesTab(
          data: ProposalApprovalTabType.finalProposals,
          child: Text(context.l10n.noOfFinal(finalCount)),
        ),
      ],
    );
  }
}

class _TabBarView extends StatelessWidget {
  final TabController tabController;
  final List<UsersProposalOverview> decideItems;
  final List<UsersProposalOverview> finalItems;

  const _TabBarView({
    required this.tabController,
    required this.decideItems,
    required this.finalItems,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarStackView(
      controller: tabController,
      children: [
        ProposalApprovalDecideTab(items: decideItems),
        ProposalApprovalFinalTab(items: finalItems),
      ],
    );
  }
}
