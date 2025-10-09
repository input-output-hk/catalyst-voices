import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/modals/proposals/create_new_proposal_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class CreateProposalButton extends StatelessWidget {
  final SignedDocumentRef? categoryRef;
  final bool showTrailingIcon;

  const CreateProposalButton({
    super.key,
    this.categoryRef,
    this.showTrailingIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('CreateProposalButton'),
      onTap: () {
        unawaited(CreateNewProposalDialog.show(context, categoryRef: categoryRef));
      },
      trailing: Offstage(
        offstage: !showTrailingIcon,
        child: VoicesAssets.icons.plus.buildIcon(),
      ),
      child: Text(context.l10n.createProposal),
    );
  }
}

class ResponsiveCreateProposalButton extends StatelessWidget {
  final SignedDocumentRef? categoryRef;

  const ResponsiveCreateProposalButton({
    super.key,
    this.categoryRef,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveChildBuilder(
      key: const Key('CreateProposalButton'),
      xs: (context) => VoicesIconButton.outlined(
        onTap: () => _onTap(context),
        child: VoicesAssets.icons.plus.buildIcon(),
      ),
      sm: (context) => VoicesFilledButton(
        onTap: () => _onTap(context),
        child: Text(context.l10n.createProposal),
      ),
    );
  }

  void _onTap(BuildContext context) {
    unawaited(CreateNewProposalDialog.show(context, categoryRef: categoryRef));
  }
}
