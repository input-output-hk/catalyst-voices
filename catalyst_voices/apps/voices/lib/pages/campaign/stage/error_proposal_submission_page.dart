import 'package:catalyst_voices/pages/campaign/stage/campaign_background.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ErrorProposalSubmissionPage extends StatelessWidget {
  const ErrorProposalSubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CampaignBackground(
      child: VoicesErrorIndicator(
        message: const LocalizedUnknownException().message(context),
        onRetry: () async =>
            context.read<CampaignStageCubit>().getCampaignStage(),
      ),
    );
  }
}
