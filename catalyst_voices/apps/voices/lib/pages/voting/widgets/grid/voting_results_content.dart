import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VotingResultsContent extends StatelessWidget {
  const VotingResultsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 96),
          Text(
            context.l10n.votingResultsHeader,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 42,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.votingResultsSubheader,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colors.textOnPrimaryLevel1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          Text(
            context.l10n.votingResultsMessage,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colors.textOnPrimaryLevel1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          const _Button(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget with LaunchUrlMixin {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, int?>(
      selector: (state) => state.fundNumber,
      builder: (context, fundNumber) {
        return VoicesFilledButton(
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          onTap: fundNumber == null
              ? null
              : () => launchUri(Uri.parse(VoicesConstants.fundVotingResultsUrl(fundNumber))),
          child: Text(context.l10n.votingResultsButton),
        );
      },
    );
  }
}
