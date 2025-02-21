import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DraftProposalChip extends StatelessWidget {
  const DraftProposalChip({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Text(
        context.l10n.draft,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      backgroundColor: Theme.of(context).colors.iconsSecondary,
    );
  }
}

class FinalProposalChip extends StatelessWidget {
  const FinalProposalChip({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Text(
        context.l10n.finalProposal,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ProposalVersionChip extends StatelessWidget {
  final String version;

  const ProposalVersionChip({
    super.key,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Row(
        spacing: 6,
        children: [
          VoicesAssets.icons.documentText.buildIcon(size: 18),
          Text(
            version,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colors.textOnPrimaryLevel1,
                ),
          ),
        ],
      ),
    );
  }
}
