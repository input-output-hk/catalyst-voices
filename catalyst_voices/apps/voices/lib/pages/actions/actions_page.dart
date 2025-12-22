import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/actions_page_tab.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
      children: [
        const _Header(),
        const SizedBox(height: 30),
        _Content(tab),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final ActionsPageTab tab;

  const _Content(this.tab);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Text(
              'Tab: ${tab.name}',
              style: context.textTheme.titleLarge,
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
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.myActions,
          style: context.textTheme.titleLarge,
        ),
        CloseButton(
          onPressed: Scaffold.of(context).closeEndDrawer,
        ),
      ],
    );
  }
}
