import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
        return Stack(
          children: [
            child,
            if (state != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          VoicesSnackBar.calculateSnackBarWidth(
                            behavior: SnackBarBehavior.floating,
                            screenWidth: MediaQuery.sizeOf(context).width,
                          ) ??
                          double.infinity,
                    ),
                    child: _SnackbarStatusSelector(validationErrors: state),
                  ),
                ),
              ),
          ],
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
    return _Snackbar(
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

class _ExitFormIssueModeDialog extends StatelessWidget {
  const _ExitFormIssueModeDialog();

  @override
  Widget build(BuildContext context) {
    return VoicesInfoDialog(
      icon: VoicesAssets.icons.exclamation.buildIcon(
        color: context.colors.iconsWarning,
      ),
      title: Text(context.l10n.proposalEditorValidationExitDialogTitle),
      message: const Offstage(),
      action: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          VoicesTextButton(
            child: Text(context.l10n.exitButtonText),
            onTap: () => Navigator.of(context).pop(true),
          ),
          VoicesFilledButton(
            child: Text(context.l10n.resumeButtonText),
            onTap: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      routeSettings: const RouteSettings(name: '/proposal-builder/exit-form-issue-mode'),
      builder: (context) => const _ExitFormIssueModeDialog(),
    );

    return result ?? false;
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
    return _Snackbar(
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
    return _Snackbar(
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

class _Snackbar extends StatelessWidget {
  final VoicesSnackBarType type;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback buttonAction;
  final VoidCallback? onExit;

  const _Snackbar({
    required this.type,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.buttonAction,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesSnackBar(
      type: type,
      title: title,
      message: message,
      showClose: false,
      actions: [
        VoicesSnackBarSecondaryAction(
          type: type,
          onPressed: buttonAction,
          child: Text(buttonText),
        ),
        VoicesSnackBarSecondaryAction(
          type: type,
          onPressed: onExit ?? () => unawaited(_onExit(context)),
          child: Text(context.l10n.proposalEditorValidationExitIssueMode),
        ),
      ],
    );
  }

  Future<void> _onExit(BuildContext context) async {
    final close = await _ExitFormIssueModeDialog.show(context);
    if (close && context.mounted) {
      context.read<ProposalBuilderBloc>().add(const ClearValidationProposalEvent());
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
