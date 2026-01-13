import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_decide_tab.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_final_tab.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_decorated_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalTabs extends StatelessWidget {
  const ProposalApprovalTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionsDecoratedPanel(
      child: BlocBuilder<ProposalApprovalCubit, ProposalApprovalState>(
        builder: (context, state) {
          return DefaultTabController(
            length: ProposalApprovalTabType.values.length,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TabBar(
                  decideCount: state.decideCount,
                  finalCount: state.finalCount,
                ),
                const Flexible(child: _TabBarView()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int decideCount;
  final int finalCount;

  const _TabBar({
    required this.decideCount,
    required this.finalCount,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTabBar(
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
  const _TabBarView();

  @override
  Widget build(BuildContext context) {
    return const TabBarStackView(
      children: [
        ProposalApprovalDecideTab(items: []),
        ProposalApprovalFinalTab(items: []),
      ],
    );
  }
}
