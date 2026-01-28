import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ViewAllCategoryProposalButton extends StatelessWidget {
  final SignedDocumentRef categoryRef;

  const ViewAllCategoryProposalButton({
    super.key,
    required this.categoryRef,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () async {
        await ProposalsRoute.fromRef(categoryRef: categoryRef).push<void>(context);
      },
      child: Text(context.l10n.viewAllProposals),
    );
  }
}
