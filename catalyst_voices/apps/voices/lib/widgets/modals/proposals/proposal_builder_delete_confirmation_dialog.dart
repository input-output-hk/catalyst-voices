import 'package:catalyst_voices/widgets/modals/voices_question_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBuilderDeleteConfirmationDialog extends StatelessWidget {
  const ProposalBuilderDeleteConfirmationDialog._();

  @override
  Widget build(BuildContext context) {
    return VoicesQuestionDialog(
      title: Text(context.l10n.proposalEditorDeleteDialogTitle),
      icon: VoicesAssets.icons.exclamation.buildIcon(
        size: 36,
        color: Theme.of(context).colors.iconsWarning,
      ),
      subtitle: Text(context.l10n.proposalEditorDeleteDialogDescription),
      actions: [
        VoicesQuestionActionItem.positive(
          context.l10n.proposalEditorDeleteDialogDeleteButton,
          type: VoicesQuestionActionType.filled,
        ),
        VoicesQuestionActionItem.negative(
          context.l10n.cancelButtonText,
          type: VoicesQuestionActionType.text,
        ),
      ],
    );
  }

  static Future<bool> show(
    BuildContext context, {
    required RouteSettings routeSettings,
  }) {
    return VoicesQuestionDialog.show(
      context,
      routeSettings: routeSettings,
      builder: (_) => const ProposalBuilderDeleteConfirmationDialog._(),
    );
  }
}
