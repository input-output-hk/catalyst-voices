import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_validation_snackbar.dart';
import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_validation_snackbar_scaffold.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBuilderValidationSnackbarOverlay extends StatelessWidget {
  final Widget child;

  const ProposalBuilderValidationSnackbarOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProposalBuilderBloc,
      ProposalBuilderState,
      ProposalBuilderValidationErrors?
    >(
      selector: (state) => state.validationErrors,
      builder: (context, state) {
        return DocumentBuilderValidationSnackbarScaffold(
          snackbar: state != null ? _SnackbarStatusSelector(validationErrors: state) : null,
          child: child,
        );
      },
    );
  }
}

class _ClearedSnackbar extends StatelessWidget {
  final ProposalBuilderValidationOrigin origin;

  const _ClearedSnackbar({required this.origin});

  @override
  Widget build(BuildContext context) {
    return DocumentBuilderValidationSnackbar(
      type: VoicesSnackBarType.success,
      title: context.l10n.proposalEditorValidationErrorClearedTitle,
      message: switch (origin) {
        ProposalBuilderValidationOrigin.shareDraft =>
          context.l10n.proposalEditorValidationErrorShareDraftClearedMessage,
        ProposalBuilderValidationOrigin.submitForReview =>
          context.l10n.proposalEditorValidationErrorSubmitReviewClearedMessage,
      },
      buttonText: switch (origin) {
        ProposalBuilderValidationOrigin.shareDraft => context.l10n.shareNewDraft,
        ProposalBuilderValidationOrigin.submitForReview => context.l10n.submitForReview,
      },
      buttonAction: () {
        final event = switch (origin) {
          ProposalBuilderValidationOrigin.shareDraft => const RequestPublishProposalEvent(),
          ProposalBuilderValidationOrigin.submitForReview => const RequestSubmitProposalEvent(),
        };

        context.read<ProposalBuilderBloc>().add(event);
      },
      onExit: () {
        context.read<ProposalBuilderBloc>().add(const ClearValidationProposalEvent());
      },
    );
  }
}

class _NotStartedSnackbar extends StatelessWidget {
  final ProposalBuilderValidationOrigin origin;
  final int errorCount;

  const _NotStartedSnackbar({
    required this.origin,
    required this.errorCount,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentBuilderValidationSnackbar(
      type: VoicesSnackBarType.error,
      title: switch (origin) {
        ProposalBuilderValidationOrigin.shareDraft =>
          context.l10n.proposalEditorValidationErrorShareDraftTitle(errorCount),
        ProposalBuilderValidationOrigin.submitForReview =>
          context.l10n.proposalEditorValidationErrorSubmitReviewTitle(errorCount),
      },
      message: switch (origin) {
        ProposalBuilderValidationOrigin.shareDraft =>
          context.l10n.proposalEditorValidationErrorShareDraftNotStartedMessage,
        ProposalBuilderValidationOrigin.submitForReview =>
          context.l10n.proposalEditorValidationErrorSubmitReviewNotStartedMessage,
      },
      buttonText: context.l10n.startButtonText,
      buttonAction: () {
        const event = UpdateProposalBuilderValidationStatusEvent(
          status: DocumentBuilderValidationStatus.pendingHideAll,
        );
        context.read<ProposalBuilderBloc>().add(event);
      },
      onExit: () {
        context.read<ProposalBuilderBloc>().add(const ClearValidationProposalEvent());
      },
    );
  }
}

class _PendingSnackbar extends StatelessWidget {
  final ProposalBuilderValidationOrigin origin;
  final bool showAll;
  final List<String> errors;

  const _PendingSnackbar({
    required this.origin,
    required this.showAll,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentBuilderValidationSnackbar(
      type: VoicesSnackBarType.error,
      title: switch (origin) {
        ProposalBuilderValidationOrigin.shareDraft =>
          context.l10n.proposalEditorValidationErrorShareDraftTitle(errors.length),
        ProposalBuilderValidationOrigin.submitForReview =>
          context.l10n.proposalEditorValidationErrorSubmitReviewTitle(errors.length),
      },
      message: _buildMessage(context),
      buttonText: switch (showAll) {
        true => context.l10n.hideAllIssues,
        false => context.l10n.showAllIssues,
      },
      buttonAction: () {
        final event = switch (showAll) {
          true => const UpdateProposalBuilderValidationStatusEvent(
            status: DocumentBuilderValidationStatus.pendingHideAll,
          ),
          false => const UpdateProposalBuilderValidationStatusEvent(
            status: DocumentBuilderValidationStatus.pendingShowAll,
          ),
        };

        context.read<ProposalBuilderBloc>().add(event);
      },
      onExit: () {
        context.read<ProposalBuilderBloc>().add(const ClearValidationProposalEvent());
      },
    );
  }

  String _buildMessage(BuildContext context) {
    if (showAll) {
      return errors.map((e) => '   • $e').join('\n');
    } else {
      return context.l10n.proposalEditorValidationErrorInProgressMessage;
    }
  }
}

class _SnackbarStatusSelector extends StatelessWidget {
  final ProposalBuilderValidationErrors validationErrors;

  const _SnackbarStatusSelector({required this.validationErrors});

  @override
  Widget build(BuildContext context) {
    switch (validationErrors.status) {
      case DocumentBuilderValidationStatus.notStarted:
        return _NotStartedSnackbar(
          origin: validationErrors.origin,
          errorCount: validationErrors.errors.length,
        );
      case DocumentBuilderValidationStatus.pendingShowAll:
        return _PendingSnackbar(
          origin: validationErrors.origin,
          showAll: true,
          errors: validationErrors.errors,
        );
      case DocumentBuilderValidationStatus.pendingHideAll:
        return _PendingSnackbar(
          origin: validationErrors.origin,
          showAll: false,
          errors: validationErrors.errors,
        );
      case DocumentBuilderValidationStatus.cleared:
        return _ClearedSnackbar(origin: validationErrors.origin);
    }
  }
}
