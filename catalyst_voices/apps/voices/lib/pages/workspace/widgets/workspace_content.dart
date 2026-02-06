import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/widgets/user_proposals/user_proposals.dart';
import 'package:catalyst_voices/pages/workspace/widgets/workspace_proposal_filters.dart';
import 'package:catalyst_voices/widgets/separators/voices_divider.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class WorkspaceContent extends StatelessWidget {
  const WorkspaceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      sliver: SliverMainAxisGroup(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _Header(),
          ),
          SliverToBoxAdapter(
            child: _Divider(),
          ),
          SliverToBoxAdapter(
            child: WorkspaceProposalFilters(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          UserProposals(),
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
