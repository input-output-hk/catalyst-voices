import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/material.dart';

/// Localized exception thrown when a proposal builder fails to publish a proposal.
final class ProposalBuilderPublishException extends LocalizedException {
  const ProposalBuilderPublishException();

  @override
  String message(BuildContext context) {
    return context.l10n.proposalEditorPublishErrorDialogMessage;
  }

  String title(BuildContext context) {
    return context.l10n.proposalEditorPublishErrorDialogTitle;
  }
}

/// Localized exception thrown when a proposal builder fails to submit a proposal.
final class ProposalBuilderSubmitException extends LocalizedException {
  const ProposalBuilderSubmitException();

  @override
  String message(BuildContext context) {
    return context.l10n.proposalEditorSubmitErrorDialogMessage;
  }

  String title(BuildContext context) {
    return context.l10n.proposalEditorSubmitErrorDialogTitle;
  }
}
