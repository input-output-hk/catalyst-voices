import 'package:catalyst_voices/pages/actions/actions_page.dart';
import 'package:catalyst_voices/pages/co_proposers_consent/co_proposers_consent_page.dart';
import 'package:catalyst_voices/pages/proposal_approval/proposal_approval_page.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:flutter/material.dart';

/// Shell page that provides the drawer container for actions navigation.
///
/// The [child] parameter is the navigator that displays the current
/// sub-route content ([ActionsPage], [CoProposersConsentPage],
/// [ProposalApprovalPage]).
class ActionsShellPage extends StatelessWidget {
  final Widget child;

  const ActionsShellPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}
