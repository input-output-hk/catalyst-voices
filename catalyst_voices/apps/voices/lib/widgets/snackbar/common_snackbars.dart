import 'package:catalyst_voices/pages/proposal_builder/proposal_builder.dart'
    show ProposalBuilderPage;
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_page.dart'
    show ProposalBuilderPage;
import 'package:catalyst_voices/pages/workspace/page/workspace_page.dart' show WorkspacePage;
import 'package:catalyst_voices/pages/workspace/workspace.dart' show WorkspacePage;
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// Place to collect reusable snackbars across different pages.
final class CommonSnackbars {
  /// Shows a snackbar with success message about proposal forgetting.
  /// Used in [WorkspacePage] and [ProposalBuilderPage].
  static void showForgetProposalSuccessDialog(BuildContext context) {
    VoicesSnackBar.hideCurrent(context);

    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.successProposalForgot,
      message: context.l10n.successProposalForgotDescription,
    ).show(context);
  }
}
