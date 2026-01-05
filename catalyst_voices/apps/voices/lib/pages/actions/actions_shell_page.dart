import 'package:catalyst_voices/pages/actions/actions/actions_page.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/co_proposers_consent_page.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/proposal_approval_page.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: child,
      ),
    );
  }

  /// This page is designed to work "as a Drawer". It works in assumption that
  /// it's route([ActionsShellRoute]) is using [EndDrawerShellPageTransitionMixin] which
  /// puts child's in [Scaffold] end drawer property.
  static void close(BuildContext context) {
    Scaffold.of(context).closeEndDrawer();
  }
}
