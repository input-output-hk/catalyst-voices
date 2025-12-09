import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/material.dart';

/// An exception thrown attempting to create / import a new
/// proposal when the user has reached the limit.
final class ProposalBuilderLimitReachedException extends LocalizedException {
  const ProposalBuilderLimitReachedException();

  @override
  String message(BuildContext context) {
    return context.l10n.proposalEditorLimitReachedErrorMessage;
  }

  String title(BuildContext context) {
    return context.l10n.proposalEditorLimitReachedErrorTitle;
  }
}

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
