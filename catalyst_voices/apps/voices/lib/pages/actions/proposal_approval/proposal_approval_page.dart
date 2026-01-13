import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_tabs.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalApprovalPage extends StatefulWidget {
  const ProposalApprovalPage({super.key});

  @override
  State<ProposalApprovalPage> createState() => _ProposalApprovalPageState();
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ProposalApprovalTabs(),
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
        text: context.l10n.proposalApprovalHeader,
        onCloseTap: () => ActionsShellPage.close(context),
        showBackButton: true,
      ),
    );
  }
}

class _ProposalApprovalPageState extends State<ProposalApprovalPage> {
  late final ProposalApprovalCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(),
          SizedBox(height: 16),
          _Subheader(),
          SizedBox(height: 20),
          _Content(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _cubit = Dependencies.instance.get<ProposalApprovalCubit>();
    _cubit.init();
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
