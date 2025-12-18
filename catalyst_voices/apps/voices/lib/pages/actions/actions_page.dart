import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Header(),
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
        child: Column(
          spacing: 20,
          children: [
            Text(
              'No actions',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
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
