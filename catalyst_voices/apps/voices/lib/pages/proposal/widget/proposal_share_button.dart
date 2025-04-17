import 'dart:async';

import 'package:catalyst_voices/routes/routing/proposal_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/modals/proposals/share_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalShareButton extends StatelessWidget {
  const ProposalShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, DocumentRef?>(
      selector: (state) {
        return state.data.header.proposalRef;
      },
      builder: (context, proposalRef) {
        return ShareButton(
          onTap: () {
            if (proposalRef != null) {
              final url = ProposalRoute.fromRef(ref: proposalRef).location;
              unawaited(ShareProposalDialog.show(context, url));
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
