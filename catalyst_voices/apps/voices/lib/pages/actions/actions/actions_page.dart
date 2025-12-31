import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/actions_tabs_group.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  final ActionsPageTab tab;

  const ActionsPage({
    super.key,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        VoicesDrawerHeader(
          text: context.l10n.myActions,
          onCloseTap: () => ActionsShellPage.close(context),
        ),
        _Content(tab),
      ],
    );
  }
}

class _Content extends StatefulWidget {
  final ActionsPageTab tab;

  const _Content(this.tab);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late ActionsPageTab selectedTab;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          const _HeaderText(),
          ActionsTabsGroup(
            selectedTab: selectedTab,
            onChanged: _onTabChanged,
          ),
          VoicesFilledButton(
            child: const Text('Proposal Approval'),
            onTap: () {
              unawaited(const ProposalApprovalRoute().push(context));
            },
          ),
          VoicesFilledButton(
            child: const Text('Co-Proposer Display Consent'),
            onTap: () {
              unawaited(const CoProposersConsentRoute().push(context));
            },
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(_Content oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tab != widget.tab) {
      _onTabChanged(widget.tab);
    }
  }

  @override
  void initState() {
    super.initState();
    _onTabChanged(widget.tab);
  }

  void _onTabChanged(ActionsPageTab? newTab) {
    if (newTab != null) {
      setState(() {
        selectedTab = newTab;
      });
      // TODO(LynxLynxx): Call bloc to update the actions list based on the selected tab
    }
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.myActionsPageHeader,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
    );
  }
}
