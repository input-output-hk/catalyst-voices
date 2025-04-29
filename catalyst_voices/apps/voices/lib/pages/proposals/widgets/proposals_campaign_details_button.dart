import 'dart:async';

import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalsCampaignDetailsButton extends StatelessWidget {
  const ProposalsCampaignDetailsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignInfoCubit, CampaignInfoState, String?>(
      selector: (state) => state.campaign?.id,
      builder: (context, campaignId) {
        return _ProposalsCampaignDetailsButton(campaignId: campaignId);
      },
    );
  }
}

class _ProposalsCampaignDetailsButton extends StatelessWidget {
  final String? campaignId;

  const _ProposalsCampaignDetailsButton({
    required this.campaignId,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: campaignId == null,
      child: Padding(
        key: const Key('CampaignDetailsButton'),
        padding: const EdgeInsets.only(top: 32),
        child: OutlinedButton.icon(
          onPressed: () {
            unawaited(
              CampaignDetailsDialog.show(context, id: campaignId!),
            );
          },
          label: Text(context.l10n.campaignDetails),
          icon: VoicesAssets.icons.arrowsExpand.buildIcon(),
        ),
      ),
    );
  }
}
