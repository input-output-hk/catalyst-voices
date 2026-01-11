import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalApprovalPage extends StatelessWidget {
  const ProposalApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(),
        SizedBox(height: 16),
        _Subheader(),
        SizedBox(height: 30),
        _Content(),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'No actions',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
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

class _Subheader extends StatelessWidget {
  const _Subheader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        context.l10n.proposalApprovalSubheader,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colors.textOnPrimaryLevel1,
        ),
      ),
    );
  }
}
