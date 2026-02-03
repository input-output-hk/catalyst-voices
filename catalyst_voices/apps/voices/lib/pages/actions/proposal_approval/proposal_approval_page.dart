import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_tabs.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_hint_card.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalPage extends StatefulWidget {
  const ProposalApprovalPage({super.key});

  @override
  State<ProposalApprovalPage> createState() => _ProposalApprovalPageState();
}

class _Content extends StatelessWidget {
  final VoicesTabController<ProposalApprovalTabType> tabController;

  const _Content({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListenableBuilder(
        listenable: tabController,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              // there's a stack which displays a footer above the list, reserve some extra space
              // so that the last list item can be scrolled upwards enough to be fully visible
              bottom: tabController.tab == ProposalApprovalTabType.finalProposals ? 120 : 0,
            ),
            child: child,
          );
        },
        child: ProposalApprovalTabs(tabController: tabController),
      ),
    );
  }
}

class _FooterHint extends StatelessWidget {
  final VoicesTabController<ProposalApprovalTabType> tabController;

  const _FooterHint({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tabController,
      builder: (context, child) {
        return Offstage(
          offstage: tabController.tab != ProposalApprovalTabType.finalProposals,
          child: child,
        );
      },
      child: ActionsHintCard(
        title: context.l10n.headsUpProposalApprovalHintTitle,
        description: Text(context.l10n.headsUpProposalApprovalHintContent),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 22),
      child: VoicesDrawerHeader(
        title: Text(context.l10n.proposalApprovalHeader),
        onCloseTap: () => ActionsShellPage.close(context),
        showBackButton: true,
      ),
    );
  }
}

class _ProposalApprovalPageState extends State<ProposalApprovalPage>
    with SingleTickerProviderStateMixin {
  late final ProposalApprovalCubit _cubit;
  late final VoicesTabController<ProposalApprovalTabType> _tabController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Header(),
                const SizedBox(height: 16),
                const _Subheader(),
                const SizedBox(height: 20),
                _Content(tabController: _tabController),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _FooterHint(tabController: _tabController),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    unawaited(_cubit.close());

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _cubit = Dependencies.instance.get<ProposalApprovalCubit>();
    _cubit.init();

    _tabController = VoicesTabController(
      initialTab: ProposalApprovalTabType.decide,
      vsync: this,
      tabs: ProposalApprovalTabType.values,
    );
  }
}

class _Subheader extends StatelessWidget {
  const _Subheader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ActionsHeaderText(
        text: context.l10n.proposalApprovalSubheader,
      ),
    );
  }
}
