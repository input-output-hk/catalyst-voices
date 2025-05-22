import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ViewAllCategoryProposalButton extends StatelessWidget {
  final SignedDocumentRef categoryId;

  const ViewAllCategoryProposalButton({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () async {
        await ProposalsRoute.fromRef(categoryId: categoryId).push<void>(context);
      },
      child: Text(context.l10n.viewAllProposals),
    );
  }
}
