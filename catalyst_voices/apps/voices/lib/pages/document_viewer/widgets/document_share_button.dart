import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/modals/proposals/share_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentShareButton extends StatelessWidget {
  const DocumentShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentViewerCubit, DocumentViewerState, DocumentRef?>(
      selector: (state) {
        return state.data.header.documentRef;
      },
      builder: (context, documentId) {
        return ShareButton(
          onTap: () {
            if (documentId != null) {
              unawaited(ShareProposalDialog.show(context, ref: documentId));
            } else {
              _showErrorSnackbar(context);
            }
          },
        );
      },
    );
  }

  void _showErrorSnackbar(BuildContext context) {
    VoicesSnackBar.hideCurrent(context);

    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.somethingWentWrong,
      message: context.l10n.shareProposalErrorDescription,
    ).show(context);
  }
}
