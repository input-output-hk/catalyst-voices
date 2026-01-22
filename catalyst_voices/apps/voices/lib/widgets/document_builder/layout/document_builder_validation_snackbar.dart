import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_validation_snackbar_scaffold.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_info_dialog.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A validation snackbar which is used to display validation errors for the document builder.
///
/// Intended to work with the [DocumentBuilderValidationSnackbarScaffold].
class DocumentBuilderValidationSnackbar extends StatelessWidget {
  final VoicesSnackBarType type;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback buttonAction;
  final VoidCallback onExit;

  const DocumentBuilderValidationSnackbar({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.buttonAction,
    required this.onExit,
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
          onPressed: () => unawaited(_onExit(context)),
          child: Text(context.l10n.documentBuilderValidationExitIssueMode),
        ),
      ],
    );
  }

  Future<void> _onExit(BuildContext context) async {
    if (type == VoicesSnackBarType.success) {
      // success snackbar doesn't require validation
      onExit();
      return;
    }

    final close = await _ExitFormIssueModeDialog.show(context);
    if (close && context.mounted) {
      onExit();
    }
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
      title: Text(context.l10n.documentBuilderValidationExitDialogTitle),
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
      routeSettings: const RouteSettings(name: '/document-builder/exit-form-issue-mode'),
      builder: (context) => const _ExitFormIssueModeDialog(),
    );

    return result ?? false;
  }
}
