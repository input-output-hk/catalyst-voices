import 'package:catalyst_voices/pages/proposals/widgets/proposals_campaign_details_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalsFundInfo extends StatelessWidget {
  const ProposalsFundInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            key: const Key('CurrentCampaignTitle'),
            context.l10n.catalystF14,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            key: const Key('CurrentCampaignDescription'),
            context.l10n.currentCampaignDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const ProposalsCampaignDetailsButton(),
        ],
      ),
    );
  }
}
