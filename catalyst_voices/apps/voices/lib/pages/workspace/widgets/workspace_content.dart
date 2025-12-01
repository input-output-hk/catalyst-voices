import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/widgets/user_proposal_invites/user_proposal_invites_section.dart';
import 'package:catalyst_voices/pages/workspace/widgets/user_proposals/user_proposals.dart';
import 'package:catalyst_voices/pages/workspace/widgets/workspace_proposal_filters.dart';
import 'package:catalyst_voices/pages/workspace/widgets/workspace_tabs.dart';
import 'package:catalyst_voices/widgets/separators/voices_divider.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceContent extends StatelessWidget {
  final VoicesTabController<WorkspacePageTab> tabController;

  const WorkspaceContent({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      sliver: SliverMainAxisGroup(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: _Header(),
          ),
          SliverToBoxAdapter(
            child: WorkspaceTabs(tabController: tabController),
          ),
          const SliverToBoxAdapter(
            child: _Divider(),
          ),
          SliverToBoxAdapter(
            child: WorkspaceProposalFilters(
              tabController: tabController,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          _WorkspaceTabView(
            tabController: tabController,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return VoicesDivider.expanded(
      height: 1,
      color: context.colorScheme.primary,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.myProposals,
      style: context.textTheme.headlineSmall,
    );
  }
}

class _WorkspaceTabView extends StatelessWidget {
  final VoicesTabController<WorkspacePageTab> tabController;

  const _WorkspaceTabView({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tabController,
      builder: (context, child) {
        return switch (tabController.tab) {
          WorkspacePageTab.proposals => const UserProposals(),
          WorkspacePageTab.proposalInvites => const UserProposalInvitesSection(),
        };
      },
    );
  }
}
